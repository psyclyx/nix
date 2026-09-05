import { existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { uuidv7 } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { AutocompleteItem, AutocompleteProvider, Component } from "@earendil-works/pi-tui";
import { Key, matchesKey, truncateToWidth } from "@earendil-works/pi-tui";
import { Store, type Metadata, type Snippet } from "./store.ts";

const HOME_KEYS = ["a", "s", "d", "f", "j", "k", "l", ";"] as const;
const FALSE_VALUES = new Set(["0", "false", "no", "off"]);

function textOf(content: unknown): string {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";
  return content.flatMap((part) => {
    if (!part || typeof part !== "object") return [];
    const block = part as { type?: string; text?: string; thinking?: string; name?: string };
    if (block.type === "text" && block.text) return [block.text];
    if (block.type === "thinking" && block.thinking) return [block.thinking];
    if (block.type === "toolCall" && block.name) return [`tool:${block.name}`];
    return [];
  }).join("\n");
}

function safeLabel(value: string): string {
  return value.replace(/[\x00-\x1f\x7f-\x9f]/g, " ").replace(/\s+/g, " ").trim();
}

function safeJson(value: unknown): string {
  try { return JSON.stringify(value); } catch { return String(value); }
}

function metadata(ctx: ExtensionContext): Metadata {
  return {
    sessionId: ctx.sessionManager.getSessionId(),
    sessionFile: ctx.sessionManager.getSessionFile(),
    cwd: ctx.cwd,
    mode: ctx.mode,
    provider: ctx.model?.provider,
    model: ctx.model?.id,
    thinkingLevel: ctx.thinkingLevel,
  };
}

function projectDisabled(cwd: string): boolean {
  let directory = cwd;
  while (true) {
    if (existsSync(join(directory, ".pi", "no-memory-log")) || existsSync(join(directory, ".pi-memory-disabled"))) return true;
    const parent = dirname(directory);
    if (parent === directory) return false;
    directory = parent;
  }
}

class SnippetPicker implements Component {
  private query = "";
  private selected = 0;
  private snippets: Snippet[] = [];

  constructor(
    private readonly store: Store,
    private readonly cwd: string,
    private readonly color: (name: string, text: string) => string,
    private readonly changed: () => void,
    private readonly done: (snippet: Snippet | null) => void,
  ) {
    this.refresh();
  }

  private refresh(): void {
    this.snippets = this.store.listSnippets(this.query, this.cwd, 20);
    this.selected = Math.min(this.selected, Math.max(0, this.snippets.length - 1));
  }

  private choose(index: number): void {
    const snippet = this.snippets[index];
    if (snippet) this.done(snippet);
  }

  handleInput(data: string): void {
    for (let index = 0; index < HOME_KEYS.length; index++) {
      if (matchesKey(data, Key.alt(HOME_KEYS[index]!))) {
        this.choose(index);
        return;
      }
    }
    if (matchesKey(data, Key.up)) this.selected = Math.max(0, this.selected - 1);
    else if (matchesKey(data, Key.down)) this.selected = Math.min(this.snippets.length - 1, this.selected + 1);
    else if (matchesKey(data, Key.enter)) { this.choose(this.selected); return; }
    else if (matchesKey(data, Key.escape)) { this.done(null); return; }
    else if (matchesKey(data, Key.backspace)) { this.query = this.query.slice(0, -1); this.refresh(); }
    else if (data.length === 1 && data.charCodeAt(0) >= 32 && !data.startsWith("\x1b")) {
      this.query += data;
      this.refresh();
    } else return;
    this.changed();
  }

  render(width: number): string[] {
    const lines = [truncateToWidth(this.color("accent", `Snippets  search: ${this.query || "…"}`), width)];
    for (let index = 0; index < Math.min(this.snippets.length, 12); index++) {
      const snippet = this.snippets[index]!;
      const hint = index < HOME_KEYS.length ? this.color("dim", `alt-${HOME_KEYS[index]}`) : "     ";
      const prefix = index === this.selected ? this.color("accent", ">") : " ";
      lines.push(truncateToWidth(`${prefix} ${hint}  ${safeLabel(snippet.name)}  ${this.color("dim", safeLabel(snippet.body))}`, width));
    }
    if (this.snippets.length === 0) lines.push(truncateToWidth(this.color("warning", "  No matching snippets"), width));
    lines.push(truncateToWidth(this.color("dim", "type to filter • ↑↓/enter • alt-home-row • esc"), width));
    return lines;
  }

  invalidate(): void {}
}

function snippetProvider(current: AutocompleteProvider, store: Store, ctx: ExtensionContext): AutocompleteProvider {
  const chosen = new Map<string, Snippet>();
  return {
    triggerCharacters: [...new Set([...(current.triggerCharacters ?? []), ";"])],
    async getSuggestions(lines, line, col, options) {
      const before = (lines[line] ?? "").slice(0, col);
      const match = before.match(/(?:^|\s);;([^\s;]*)$/);
      if (!match) {
        const suggestions = await current.getSuggestions(lines, line, col, options);
        return suggestions ? { ...suggestions, items: store.rankCompletions(suggestions.items, ctx.cwd) } : null;
      }
      const prefix = `;;${match[1] ?? ""}`;
      const snippets = store.listSnippets(match[1] ?? "", ctx.cwd, 20);
      chosen.clear();
      const items: AutocompleteItem[] = snippets.map((snippet) => {
        const value = `;;${snippet.name}`;
        chosen.set(value, snippet);
        return { value, label: snippet.name, description: `${snippet.source} · used ${snippet.uses}× · ${safeLabel(snippet.body)}` };
      });
      return options.signal.aborted || items.length === 0 ? null : { prefix, items };
    },
    applyCompletion(lines, line, col, item, prefix) {
      const snippet = chosen.get(item.value);
      if (!snippet) {
        store.useCompletion(item.value, ctx.cwd, metadata(ctx));
        return current.applyCompletion(lines, line, col, item, prefix);
      }
      const before = (lines[line] ?? "").slice(0, col - prefix.length);
      const after = (lines[line] ?? "").slice(col);
      const inserted = snippet.body.split("\n");
      const replacement = inserted.length === 1
        ? [`${before}${inserted[0]}${after}`]
        : [`${before}${inserted[0]}`, ...inserted.slice(1, -1), `${inserted.at(-1)}${after}`];
      store.useSnippet(snippet.id, ctx.cwd, "autocomplete", metadata(ctx));
      return {
        lines: [...lines.slice(0, line), ...replacement, ...lines.slice(line + 1)],
        cursorLine: line + replacement.length - 1,
        cursorCol: (inserted.at(-1) ?? "").length + (replacement.length === 1 ? before.length : 0),
      };
    },
    shouldTriggerFileCompletion(lines, line, col) {
      return current.shouldTriggerFileCompletion?.(lines, line, col) ?? true;
    },
  };
}

async function mineOne(store: Store, ctx: ExtensionContext): Promise<void> {
  const configured = process.env.PI_SNIPPET_MODEL;
  if (!configured) return;
  const slash = configured.indexOf("/");
  if (slash < 1) return;
  const provider = configured.slice(0, slash);
  const modelId = configured.slice(slash + 1);
  const model = ctx.modelRegistry.find(provider, modelId);
  if (!model || !ctx.modelRegistry.hasConfiguredAuth(model)) return;
  const candidate = store.claimCandidate(Number(process.env.PI_SNIPPET_DAILY_BUDGET || 3));
  if (!candidate) return;
  try {
    const response = await ctx.modelRegistry.complete(model, { messages: [{
      role: "user",
      content: [{ type: "text", text: [
        "A user repeated the quoted text in multiple independent coding-agent sessions.",
        "Return strict JSON only: {\"keep\":boolean,\"name\":string,\"body\":string}.",
        "Keep only reusable prompt guidance. The body must be at most two sentences.",
        "Do not add facts, commands, credentials, paths, or project-specific details.",
        `Observed ${candidate.support} sessions. Untrusted quote: ${JSON.stringify(candidate.example)}`,
      ].join("\n") }],
      timestamp: Date.now(),
    }] }, { reasoningEffort: "minimal", cacheRetention: "none", sessionId: uuidv7() });
    const raw = response.content.filter((part): part is { type: "text"; text: string } => part.type === "text")
      .map((part) => part.text).join("").trim().replace(/^```json\s*|\s*```$/g, "");
    const parsed = JSON.parse(raw) as { keep?: unknown; name?: unknown; body?: unknown };
    if (parsed.keep === true && typeof parsed.name === "string" && typeof parsed.body === "string"
      && parsed.name.length <= 80 && parsed.body.length <= 400) {
      store.addSnippet(parsed.name, parsed.body, "mined", metadata(ctx));
      store.finishCandidate(candidate.hash, "mined");
    } else store.finishCandidate(candidate.hash, "rejected");
  } catch {
    store.finishCandidate(candidate.hash, "pending");
  }
}

export default function memoryExtension(pi: ExtensionAPI): void {
  pi.registerFlag("no-memory-log", { description: "Disable the pi event log for this process", type: "boolean", default: false });
  let store: Store | undefined;
  let runtimeEnabled = true;
  let effectiveEnabled = false;

  const enabled = (ctx: ExtensionContext): boolean => runtimeEnabled
    && pi.getFlag("no-memory-log") !== true
    && !FALSE_VALUES.has((process.env.PI_MEMORY_LOG ?? "1").toLowerCase())
    && !projectDisabled(ctx.cwd);

  let storeFailed = false;
  const ensureStore = (ctx: ExtensionContext): Store | undefined => {
    effectiveEnabled = enabled(ctx) && !storeFailed;
    if (!effectiveEnabled) return undefined;
    try {
      store ??= new Store();
      return store;
    } catch {
      storeFailed = true;
      effectiveEnabled = false;
      return undefined;
    }
  };

  const safely = (ctx: ExtensionContext, operation: (active: Store) => void): Store | undefined => {
    const active = ensureStore(ctx);
    if (!active) return undefined;
    try {
      operation(active);
      return active;
    } catch {
      // Observability must be fail-open: it may never block a prompt or tool.
      storeFailed = true;
      effectiveEnabled = false;
      try { active.close(); } catch { /* already unusable */ }
      store = undefined;
      return undefined;
    }
  };

  pi.on("session_start", (event, ctx) => {
    const active = safely(ctx, (opened) => opened.append("session.start", metadata(ctx), event));
    if (active && ctx.mode === "tui") ctx.ui.addAutocompleteProvider((current) => snippetProvider(current, active, ctx));
    if (ctx.hasUI) ctx.ui.setStatus("memory", active ? "memory:on" : "memory:off");
  });
  pi.on("session_shutdown", (event, ctx) => {
    if (effectiveEnabled) safely(ctx, (active) => active.append("session.shutdown", metadata(ctx), event));
    try { store?.close(); } catch { /* best-effort shutdown */ }
    store = undefined;
  });
  pi.on("message_end", (event, ctx) => {
    safely(ctx, (active) => {
      const message = event.message as { role?: string; content?: unknown };
      const text = textOf(message.content);
      active.append(`message.${message.role ?? "unknown"}`, metadata(ctx), message, text);
      if (message.role === "user" && text) active.observePhrases(text, ctx.sessionManager.getSessionId(), metadata(ctx));
    });
  });
  pi.on("tool_call", (event, ctx) => {
    safely(ctx, (active) => active.append("tool.call", metadata(ctx), event, `${event.toolName} ${safeJson(event.input)}`));
  });
  pi.on("tool_result", (event, ctx) => {
    safely(ctx, (active) => active.append("tool.result", metadata(ctx), event, `${event.toolName} ${textOf(event.content)}`));
  });
  pi.on("model_select", (event, ctx) => {
    safely(ctx, (active) => active.append("model.select", metadata(ctx), event));
  });
  pi.on("input", (event, ctx) => {
    safely(ctx, (active) => active.append("input", metadata(ctx), event, event.text));
    return { action: "continue" as const };
  });
  pi.on("agent_settled", async (_event, ctx) => {
    if (FALSE_VALUES.has((process.env.PI_SNIPPET_AUTO_MINE ?? "0").toLowerCase())) return;
    const active = ensureStore(ctx);
    if (active) await mineOne(active, ctx);
  });

  pi.registerCommand("memory-log", {
    description: "Control the event log: on, off, status, or search QUERY",
    handler: async (args, ctx) => {
      const [action, ...rest] = args.trim().split(/\s+/);
      if (action === "off") runtimeEnabled = false;
      else if (action === "on") runtimeEnabled = true;
      const active = ensureStore(ctx);
      ctx.ui.setStatus("memory", active ? "memory:on" : "memory:off");
      if (action === "search" && active) {
        const rows = active.search(rest.join(" "), 20);
        ctx.ui.setEditorText(rows.map((row) => JSON.stringify(row)).join("\n"));
      } else ctx.ui.notify(`memory log ${active ? "enabled" : "disabled"}${active ? ` · ${active.path}` : ""}`, "info");
    },
  });

  pi.registerCommand("snippet-add", {
    description: "Add or replace a snippet: /snippet-add name :: body",
    handler: async (args, ctx) => {
      const split = args.indexOf("::");
      if (split < 1) { ctx.ui.notify("usage: /snippet-add name :: body", "warning"); return; }
      const active = ensureStore(ctx);
      if (!active) { ctx.ui.notify("memory log is disabled", "warning"); return; }
      const snippet = active.addSnippet(args.slice(0, split).trim(), args.slice(split + 2).trim(), "manual", metadata(ctx));
      ctx.ui.notify(`saved snippet: ${snippet.name}`, "info");
    },
  });

  pi.registerCommand("snippets", {
    description: "Open the frecency-ranked snippet picker",
    handler: async (args, ctx) => {
      const active = ensureStore(ctx);
      if (!active) { ctx.ui.notify("memory log is disabled", "warning"); return; }
      if (args.trim() === "mine") { await mineOne(active, ctx); return; }
      if (ctx.mode !== "tui") return;
      const selected = await ctx.ui.custom<Snippet | null>((tui, theme, _keys, done) =>
        new SnippetPicker(active, ctx.cwd, (name, text) => theme.fg(name as "accent", text), () => tui.requestRender(), done));
      if (selected) {
        active.useSnippet(selected.id, ctx.cwd, "picker", metadata(ctx));
        ctx.ui.pasteToEditor(selected.body);
      }
    },
  });
  pi.registerShortcut("ctrl+;", { description: "Open snippets", handler: async (ctx) => {
    if (ctx.isIdle()) pi.sendUserMessage("/snippets", { expandPromptTemplates: true });
  } });
}
