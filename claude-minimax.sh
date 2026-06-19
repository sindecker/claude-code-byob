#!/usr/bin/env bash
# ============================================================
#  claude-minimax.sh - run Claude Code against MiniMax
#
#  Points Claude Code's Anthropic-compatible client at MiniMax's
#  Anthropic-compatible endpoint, in an isolated config dir. Every model
#  slot - including the background "small/fast" model - is pinned, so no
#  request silently falls back to a different or cheaper tier.
#
#  Bring your own key: export MINIMAX_API_KEY, or put it in a .env file next to
#  this script. Nothing is hardcoded here.
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL="${MINIMAX_MODEL:-MiniMax-M3}"
export CLAUDE_CONFIG_DIR="$HOME/.claude-minimax"

KEY="${MINIMAX_API_KEY:-}"
if [ -z "$KEY" ] && [ -f "$SCRIPT_DIR/.env" ]; then
  KEY="$(grep -m1 -E '^(export )?MINIMAX_API_KEY=' "$SCRIPT_DIR/.env" | cut -d= -f2- | tr -d '\r' | tr -d '\"')"
fi
if [ -z "$KEY" ]; then
  echo "[claude-minimax] ERROR: MINIMAX_API_KEY not set."
  echo "  export it, or add MINIMAX_API_KEY=... to a .env next to this script."
  exit 1
fi

export ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic"
export ANTHROPIC_AUTH_TOKEN="$KEY"
export ANTHROPIC_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_OPUS_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_SONNET_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="$MODEL"
export CLAUDE_CODE_SUBAGENT_MODEL="$MODEL"
export ANTHROPIC_SMALL_FAST_MODEL="$MODEL"

echo "  ========================================"
echo "   claude-minimax"
echo "   Backend: MiniMax (api.minimax.io/anthropic)"
echo "   Model:   $MODEL  (all slots)"
echo "   Config:  $CLAUDE_CONFIG_DIR"
echo "  ========================================"

# Add --dangerously-skip-permissions yourself to skip permission prompts.
exec claude --model opus "$@"
