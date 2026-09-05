# Pi memory extension

A global event log and small reusable prompt snippets for the nixclyx Pi package.

## Event store

Events are inserted into `$PI_MEMORY_STORE`, defaulting to
`$XDG_STATE_HOME/pi-memory/events.sqlite3`. SQLite WAL mode permits concurrent
Pi processes; the `events` table is append-only and indexed by time, session,
kind, and FTS5 text.

Each record includes a writer ID, sequence, wall-clock timestamp, session ID,
session file, cwd, Pi mode, provider, model, thinking level, and the complete
event payload. This intentionally captures prompts, assistant messages, tool
arguments, and tool results. Protect the database as sensitive data.

Controls:

- `pi --no-memory-log`: disable for one process.
- `PI_MEMORY_LOG=0`: disable through the environment.
- `.pi/no-memory-log` or `.pi-memory-disabled`: disable a project.
- `/memory-log on|off|status`: change the current runtime only.
- `/memory-log search QUERY`: put recent FTS results in the editor.

Runtime `on` cannot override an environment, CLI, or project disable marker.

## Snippets

- `/snippet-add name :: text` creates or replaces a snippet.
- Type `;;name` and choose an autocomplete result to inline its body.
- `/snippets` or `Ctrl+;` opens a frecency-ranked picker.
- The picker supports arrows/Enter and direct `Alt-a/s/d/f/j/k/l/;` choices.

Pi 0.84 does not expose built-in picker contents or selection through the
extension API. Consequently those direct keys cannot yet be added to Pi's
built-in model, session, tree, and settings pickers without an upstream API.

## Automatic snippet mining

Repeated 6+ word sentences are discovered locally and only become candidates
after appearing in three distinct sessions. Oversized text and common secret
formats are excluded heuristically before candidate creation; this is not a
security boundary, so enable remote mining only for stores you are willing to
send candidate excerpts from.

Automatic model synthesis is off unless both variables are set:

```sh
PI_SNIPPET_AUTO_MINE=1
PI_SNIPPET_MODEL=provider/model
```

At most `PI_SNIPPET_DAILY_BUDGET` calls (default 3) are made per UTC day. Each
call sends one repeated candidate—not the event database—to the configured
model, requests strict JSON, and limits accepted snippets to 400 characters.
With `PI_SNIPPET_MODEL` set, `/snippets mine` performs a manual single attempt
without enabling automatic mining. Choose a deliberately cheap model (for
example the locally configured Luna-tier model).
