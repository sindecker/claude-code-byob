# claude-code-byob

**Bring your own backend to Claude Code.** Small wrapper launchers that run the
[Claude Code](https://docs.claude.com/en/docs/claude-code) CLI against a
non-Anthropic model provider — **DeepSeek** or **MiniMax** — over each provider's
Anthropic-compatible endpoint. No proxy, no patching Claude Code; just environment
variables set before launch.

Each launcher:

- routes Claude Code to the provider's `…/anthropic` endpoint with your key,
- runs in an **isolated config dir** (`~/.claude-deepseek` / `~/.claude-minimax`)
  so it never touches your normal Claude Code setup, sessions, or auth,
- **pins every model slot** — main, opus, sonnet, haiku, subagent, *and the
  background "small/fast" model* — to one model, so no request silently falls
  back to a different or cheaper tier,
- cleans the environment back up afterward (Windows).

> The small/fast slot matters: Claude Code uses a background model for things like
> summaries and commit messages. If you only override the main model, those
> background calls can land on whatever the provider serves by default — often a
> cheaper model you didn't ask for. These launchers pin it too.

## Requirements

- [Claude Code](https://docs.claude.com/en/docs/claude-code) installed and on your `PATH` (`claude`).
- An API key for the provider you want: DeepSeek or MiniMax.

## Setup

1. Get the launcher for your OS and provider:
   - Windows: `claude-deepseek.bat`, `claude-minimax.bat`
   - macOS / Linux: `claude-deepseek.sh`, `claude-minimax.sh`
2. Provide your key, either way:
   - set it in your shell environment: `DEEPSEEK_API_KEY` or `MINIMAX_API_KEY`, **or**
   - copy `.env.example` to `.env` (next to the launcher) and fill it in. `.env` is gitignored.
3. (macOS/Linux) `chmod +x claude-*.sh`.

## Use

```bash
# Windows
claude-deepseek
claude-minimax  "summarise this repo"

# macOS / Linux
./claude-deepseek.sh
./claude-minimax.sh  "summarise this repo"
```

Any extra arguments pass straight through to `claude`.

## Configuration

| Variable               | Purpose                                   | Default              |
| ---------------------- | ----------------------------------------- | -------------------- |
| `DEEPSEEK_API_KEY`     | DeepSeek key (or in `.env`)               | —                    |
| `MINIMAX_API_KEY`      | MiniMax key (or in `.env`)                | —                    |
| `DEEPSEEK_MODEL`       | Override the DeepSeek model                | `deepseek-v4-pro`    |
| `MINIMAX_MODEL`        | Override the MiniMax model                 | `MiniMax-M3`         |

The permission prompts are left **on** by default. If you want to skip them, add
`--dangerously-skip-permissions` to your invocation — understand what it does first.

## How it works

Claude Code talks the Anthropic Messages API. DeepSeek and MiniMax both expose an
Anthropic-compatible endpoint, so pointing `ANTHROPIC_BASE_URL` at it and supplying
the key via `ANTHROPIC_AUTH_TOKEN` is enough — the CLI works unchanged. The
launchers just set those plus the per-slot model overrides, in an isolated
`CLAUDE_CONFIG_DIR`.

## Notes

- This project ships **no system prompt** — Claude Code uses its own built-in
  prompt. Output quality depends on the third-party model you point it at; results
  will differ from Anthropic's models.
- Not affiliated with Anthropic, DeepSeek, or MiniMax. "Claude" and "Claude Code"
  are trademarks of Anthropic. Use of any provider is subject to that provider's
  terms.
- Your key is read at runtime only and never written into these files.

## License

MIT — see [LICENSE](LICENSE).
