# ccs

Claude Code Session manager. Wraps [Claude Code](https://claude.ai/claude-code) in dedicated tmux sessions with descriptions, fuzzy attach, and scheduled cron jobs.

## Install

### apt (Debian/Ubuntu)

```bash
curl -fsSL https://nurrobin.github.io/ccs/pubkey.gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/ccs.gpg

echo "deb [arch=all signed-by=/etc/apt/keyrings/ccs.gpg] https://nurrobin.github.io/ccs stable main" \
  | sudo tee /etc/apt/sources.list.d/ccs.list

sudo apt update && sudo apt install ccs
```

### Manual

Copy `ccs` to somewhere in your `PATH`:

```bash
curl -fsSL https://raw.githubusercontent.com/NurRobin/ccs/main/ccs -o ~/.local/bin/ccs
chmod +x ~/.local/bin/ccs
```

Requires `tmux` and `bash` 4+.

## Usage

```
ccs new [name] [description]  Start a new session
ccs ls                        List all sessions
ccs a [name]                  Attach (fuzzy match)
ccs kill [name]               Kill a session
ccs schedule add              Schedule a recurring job
ccs schedule ls               Show scheduled jobs
ccs schedule rm <name>        Remove a scheduled job
ccs log                       Show cron execution log
ccs gc                        Clean up orphaned metadata
```

Running `ccs` with no arguments auto-selects: no sessions shows help, one session attaches, multiple lists them.

### Sessions

```bash
cd ~/project/myapp
ccs new                       # name defaults to "myapp"
ccs new api "backend work"    # named session with description
ccs a api                     # reattach later (fuzzy: "ap" works too)
ccs kill api
```

Sessions run on a dedicated tmux socket (`ccs`), isolated from your regular tmux. Mouse scrolling, truecolor, and 50k-line scrollback are set automatically.

### Scheduling

```bash
ccs schedule add              # interactive wizard
ccs schedule ls               # view jobs
ccs schedule rm daily-review  # remove
ccs log                       # execution history
```

Jobs run via cron. Each job starts a tmux session, waits for Claude to be ready (polls for the input prompt), then sends the configured command.

## Configuration

Data is stored in `~/.local/share/ccs/` (respects `XDG_DATA_HOME`).

| Variable | Default | Description |
|---|---|---|
| `CCS_DATA_DIR` | `$XDG_DATA_HOME/ccs` | Data directory |
| `CCS_SOCKET` | `ccs` | tmux socket name |
| `NO_COLOR` | unset | Disable colored output ([no-color.org](https://no-color.org)) |

## Exit codes

| Code | Meaning |
|---|---|
| 0 | Success |
| 1 | Error (session not found, file missing, ...) |
| 2 | Usage error (invalid name, bad arguments) |

## License

[MIT](LICENSE)
