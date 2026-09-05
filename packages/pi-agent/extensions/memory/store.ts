import { createHash, randomUUID } from "node:crypto";
import { chmodSync, mkdirSync } from "node:fs";
import { homedir, hostname } from "node:os";
import { dirname, join } from "node:path";
import { DatabaseSync } from "node:sqlite";

export type Metadata = {
  sessionId: string;
  sessionFile?: string;
  cwd: string;
  mode: string;
  provider?: string;
  model?: string;
  thinkingLevel?: string;
};

export type Snippet = {
  id: string;
  name: string;
  body: string;
  source: "manual" | "mined";
  createdAt: number;
  uses: number;
  lastUsed?: number;
};

const stateRoot = process.env.XDG_STATE_HOME ?? join(homedir(), ".local", "state");
export const defaultStorePath = join(stateRoot, "pi-memory", "events.sqlite3");

function hash(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}

function json(value: unknown): string {
  try {
    return JSON.stringify(value, (_key, item) =>
      typeof item === "bigint" ? item.toString() : item,
    );
  } catch {
    return JSON.stringify({ serializationError: true, value: String(value) });
  }
}

export class Store {
  readonly path: string;
  private readonly db: DatabaseSync;
  private readonly writerId = `${hostname()}:${process.pid}:${randomUUID()}`;
  private sequence = 0;

  constructor(path = process.env.PI_MEMORY_STORE || defaultStorePath) {
    this.path = path;
    mkdirSync(dirname(path), { recursive: true, mode: 0o700 });
    if (path === defaultStorePath) chmodSync(dirname(path), 0o700);
    this.db = new DatabaseSync(path, { timeout: 5_000 });
    chmodSync(path, 0o600);
    this.db.exec(`
      PRAGMA busy_timeout = 5000;
      PRAGMA journal_mode = WAL;
      PRAGMA synchronous = NORMAL;
      PRAGMA foreign_keys = ON;
      CREATE TABLE IF NOT EXISTS events (
        rowid INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT NOT NULL UNIQUE,
        timestamp_ms INTEGER NOT NULL,
        writer_id TEXT NOT NULL,
        sequence INTEGER NOT NULL,
        kind TEXT NOT NULL,
        session_id TEXT NOT NULL,
        cwd TEXT NOT NULL,
        provider TEXT,
        model TEXT,
        metadata_json TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        search_text TEXT NOT NULL DEFAULT ''
      );
      CREATE INDEX IF NOT EXISTS events_time ON events(timestamp_ms DESC);
      CREATE INDEX IF NOT EXISTS events_session ON events(session_id, timestamp_ms);
      CREATE INDEX IF NOT EXISTS events_kind ON events(kind, timestamp_ms DESC);
      CREATE VIRTUAL TABLE IF NOT EXISTS events_fts USING fts5(
        search_text, content='events', content_rowid='rowid', tokenize='unicode61'
      );
      CREATE TRIGGER IF NOT EXISTS events_fts_insert AFTER INSERT ON events BEGIN
        INSERT INTO events_fts(rowid, search_text) VALUES (new.rowid, new.search_text);
      END;
      CREATE TABLE IF NOT EXISTS snippets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        body TEXT NOT NULL,
        source TEXT NOT NULL,
        created_at INTEGER NOT NULL
      );
      CREATE TABLE IF NOT EXISTS snippet_usage (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        snippet_id TEXT NOT NULL REFERENCES snippets(id),
        timestamp_ms INTEGER NOT NULL,
        cwd TEXT NOT NULL,
        surface TEXT NOT NULL
      );
      CREATE INDEX IF NOT EXISTS snippet_usage_lookup
        ON snippet_usage(snippet_id, timestamp_ms DESC);
      CREATE TABLE IF NOT EXISTS completion_usage (
        value TEXT NOT NULL,
        timestamp_ms INTEGER NOT NULL,
        cwd TEXT NOT NULL,
        PRIMARY KEY(value, timestamp_ms, cwd)
      );
      CREATE INDEX IF NOT EXISTS completion_usage_lookup
        ON completion_usage(value, timestamp_ms DESC);
      CREATE TABLE IF NOT EXISTS phrase_occurrences (
        phrase_hash TEXT NOT NULL,
        normalized TEXT NOT NULL,
        example TEXT NOT NULL,
        session_id TEXT NOT NULL,
        timestamp_ms INTEGER NOT NULL,
        PRIMARY KEY(phrase_hash, session_id)
      );
      CREATE TABLE IF NOT EXISTS mining_candidates (
        phrase_hash TEXT PRIMARY KEY,
        normalized TEXT NOT NULL,
        example TEXT NOT NULL,
        support INTEGER NOT NULL,
        state TEXT NOT NULL DEFAULT 'pending',
        updated_at INTEGER NOT NULL
      );
      CREATE TABLE IF NOT EXISTS mining_budget (
        day TEXT PRIMARY KEY,
        calls INTEGER NOT NULL DEFAULT 0
      );
    `);
  }

  append(kind: string, metadata: Metadata, payload: unknown, searchText = ""): void {
    const timestamp = Date.now();
    const sequence = ++this.sequence;
    const id = `${this.writerId}:${sequence}`;
    this.db.prepare(`
      INSERT INTO events (
        id, timestamp_ms, writer_id, sequence, kind, session_id, cwd,
        provider, model, metadata_json, payload_json, search_text
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).run(
      id, timestamp, this.writerId, sequence, kind, metadata.sessionId,
      metadata.cwd, metadata.provider ?? null, metadata.model ?? null,
      json(metadata), json(payload), searchText,
    );
  }

  search(query: string, limit = 20): Array<Record<string, unknown>> {
    const bounded = Math.max(1, Math.min(limit, 100));
    if (!query.trim()) {
      return this.db.prepare(`
        SELECT timestamp_ms, kind, session_id, cwd, provider, model, payload_json
        FROM events ORDER BY timestamp_ms DESC LIMIT ?
      `).all(bounded) as Array<Record<string, unknown>>;
    }
    const terms = query.match(/[\p{L}\p{N}_-]+/gu) ?? [];
    if (terms.length === 0) return [];
    const ftsQuery = terms.map((term) => `"${term.replaceAll('"', '""')}"`).join(" AND ");
    return this.db.prepare(`
      SELECT e.timestamp_ms, e.kind, e.session_id, e.cwd, e.provider, e.model,
             snippet(events_fts, 0, '[', ']', ' … ', 24) AS excerpt
      FROM events_fts JOIN events e ON e.rowid = events_fts.rowid
      WHERE events_fts MATCH ? ORDER BY rank LIMIT ?
    `).all(ftsQuery, bounded) as Array<Record<string, unknown>>;
  }

  addSnippet(name: string, body: string, source: "manual" | "mined", metadata: Metadata): Snippet {
    name = name.trim();
    const now = Date.now();
    const id = hash(name.toLowerCase()).slice(0, 24);
    this.db.prepare(`
      INSERT INTO snippets(id, name, body, source, created_at) VALUES (?, ?, ?, ?, ?)
      ON CONFLICT DO UPDATE SET name=excluded.name, body=excluded.body, source=excluded.source
    `).run(id, name, body, source, now);
    const stored = this.db.prepare("SELECT id, created_at FROM snippets WHERE name = ?").get(name) as { id: string; created_at: number };
    this.append("snippet.upsert", metadata, { id: stored.id, name, body, source }, `${name}\n${body}`);
    return { id: stored.id, name, body, source, createdAt: stored.created_at, uses: 0 };
  }

  listSnippets(query: string, cwd: string, limit = 20): Snippet[] {
    const rows = this.db.prepare(`
      SELECT s.id, s.name, s.body, s.source, s.created_at,
             count(u.id) AS uses, max(u.timestamp_ms) AS last_used,
             sum(CASE WHEN u.cwd = ? THEN 1 ELSE 0 END) AS local_uses
      FROM snippets s LEFT JOIN snippet_usage u ON u.snippet_id = s.id
      WHERE lower(s.name) LIKE ? OR lower(s.body) LIKE ?
      GROUP BY s.id
    `).all(cwd, `%${query.toLowerCase()}%`, `%${query.toLowerCase()}%`) as Array<Record<string, unknown>>;
    const now = Date.now();
    return rows.map((row) => ({
      id: String(row.id), name: String(row.name), body: String(row.body),
      source: row.source as "manual" | "mined", createdAt: Number(row.created_at),
      uses: Number(row.uses), lastUsed: row.last_used == null ? undefined : Number(row.last_used),
      score: Math.log1p(Number(row.uses)) * 2 + Math.log1p(Number(row.local_uses)) * 3
        + (row.last_used == null ? 0 : 8 * Math.exp(-(now - Number(row.last_used)) / 2_592_000_000)),
    })).sort((a, b) => Number((b as Snippet & { score: number }).score) - Number((a as Snippet & { score: number }).score)
      || a.name.localeCompare(b.name)).slice(0, limit).map(({ score: _, ...snippet }) => snippet);
  }

  useSnippet(id: string, cwd: string, surface: string, metadata: Metadata): void {
    this.db.prepare("INSERT INTO snippet_usage(snippet_id, timestamp_ms, cwd, surface) VALUES (?, ?, ?, ?)")
      .run(id, Date.now(), cwd, surface);
    this.append("snippet.used", metadata, { id, surface });
  }

  rankCompletions<T extends { value: string }>(items: T[], cwd: string): T[] {
    const statement = this.db.prepare(`
      SELECT count(*) AS uses, max(timestamp_ms) AS last_used,
             sum(CASE WHEN cwd = ? THEN 1 ELSE 0 END) AS local_uses
      FROM completion_usage WHERE value = ?
    `);
    const now = Date.now();
    return items.map((item, index) => {
      const row = statement.get(cwd, item.value) as { uses: number; last_used: number | null; local_uses: number | null };
      const score = Math.log1p(Number(row.uses)) + 2 * Math.log1p(Number(row.local_uses ?? 0))
        + (row.last_used == null ? 0 : 4 * Math.exp(-(now - Number(row.last_used)) / 2_592_000_000));
      return { item, index, score };
    }).sort((a, b) => b.score - a.score || a.index - b.index).map(({ item }) => item);
  }

  useCompletion(value: string, cwd: string, metadata: Metadata): void {
    const now = Date.now();
    this.db.prepare("INSERT OR IGNORE INTO completion_usage(value, timestamp_ms, cwd) VALUES (?, ?, ?)")
      .run(value, now, cwd);
    this.append("completion.used", metadata, { value });
  }

  observePhrases(text: string, sessionId: string, metadata: Metadata): void {
    const phrases = text.replace(/\s+/g, " ").split(/(?<=[.!?])\s+/).map((part) => part.trim())
      .filter((part) => part.length >= 32 && part.length <= 280 && part.split(/\s+/).length >= 6)
      .filter((part) => !/(?:api[_-]?key|password|secret|token|BEGIN [A-Z ]+PRIVATE KEY|\bAKIA[A-Z0-9]{16}\b|\b(?:gh[opusr]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9_-]{20,})\b|\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b|\b[A-Za-z0-9+/=_-]{48,}\b)/i.test(part));
    const insert = this.db.prepare("INSERT OR IGNORE INTO phrase_occurrences VALUES (?, ?, ?, ?, ?)");
    const count = this.db.prepare("SELECT count(*) AS n FROM phrase_occurrences WHERE phrase_hash = ?");
    const candidate = this.db.prepare(`
      INSERT INTO mining_candidates(phrase_hash, normalized, example, support, updated_at)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(phrase_hash) DO UPDATE SET
        support=max(mining_candidates.support, excluded.support), updated_at=excluded.updated_at
    `);
    for (const example of phrases) {
      const normalized = example.toLowerCase().replace(/\b\d+\b/g, "#").replace(/\s+/g, " ");
      const phraseHash = hash(normalized);
      insert.run(phraseHash, normalized, example, sessionId, Date.now());
      const support = Number((count.get(phraseHash) as { n: number }).n);
      if (support >= 3) candidate.run(phraseHash, normalized, example, support, Date.now());
    }
  }

  claimCandidate(maxCalls: number): { hash: string; example: string; support: number } | undefined {
    const day = new Date().toISOString().slice(0, 10);
    this.db.exec("BEGIN IMMEDIATE");
    try {
      this.db.prepare("UPDATE mining_candidates SET state='pending' WHERE state='processing' AND updated_at < ?")
        .run(Date.now() - 3_600_000);
      const row = this.db.prepare(`
        SELECT phrase_hash, example, support FROM mining_candidates
        WHERE state = 'pending' ORDER BY support DESC, phrase_hash LIMIT 1
      `).get() as Record<string, unknown> | undefined;
      if (!row) { this.db.exec("COMMIT"); return undefined; }
      this.db.prepare("INSERT OR IGNORE INTO mining_budget(day, calls) VALUES (?, 0)").run(day);
      const budget = this.db.prepare("UPDATE mining_budget SET calls = calls + 1 WHERE day = ? AND calls < ?").run(day, maxCalls);
      if (budget.changes !== 1) { this.db.exec("COMMIT"); return undefined; }
      this.db.prepare("UPDATE mining_candidates SET state='processing', updated_at=? WHERE phrase_hash=?")
        .run(Date.now(), String(row.phrase_hash));
      this.db.exec("COMMIT");
      return { hash: String(row.phrase_hash), example: String(row.example), support: Number(row.support) };
    } catch (error) {
      this.db.exec("ROLLBACK");
      throw error;
    }
  }

  finishCandidate(hashValue: string, state: "pending" | "mined" | "rejected" | "error"): void {
    this.db.prepare("UPDATE mining_candidates SET state = ?, updated_at = ? WHERE phrase_hash = ?")
      .run(state, Date.now(), hashValue);
  }

  close(): void {
    this.db.close();
  }
}
