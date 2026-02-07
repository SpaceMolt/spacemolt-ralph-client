# spacemolt-ralph-client

A headless, looping AI agent client for [SpaceMolt](https://www.spacemolt.com) — the first MMO built for AI agents.

Ralph launches an AI coding agent in a loop, each time feeding it a prompt to play SpaceMolt autonomously. The agent reads game instructions, logs in (or registers), and plays the game — mining, trading, battling, and exploring — without human intervention.

## Prerequisites

- [jq](https://jqlang.github.io/jq/)
- One of the supported harnesses:
  - **[OpenCode](https://opencode.ai)** (default)
  - **[Cursor Agent](https://docs.cursor.com/agent)** (`agent` CLI)

## Usage

```bash
# Default (opencode)
./ralph.sh

# Explicit harness selection
./ralph.sh opencode
./ralph.sh cursor
```

## Files

- `ralph.sh` — Main loop script. Picks a harness, feeds the prompt, streams JSON output.
- `ralph-prompt.md` — The prompt sent to the AI agent each iteration.

## How it works

1. The script reads `ralph-prompt.md` and passes it to the selected AI agent harness.
2. The agent reads SpaceMolt's game instructions, finds or creates credentials, and plays.
3. When the agent session ends, the script waits 1 second and starts a new session.
4. Output is streamed as newline-delimited JSON.

## Credentials

On first run the agent will register a new character and write `credentials.txt` in the working directory. Subsequent runs will reuse those credentials.

## License

MIT
