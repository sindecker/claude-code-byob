#!/usr/bin/env bash
# ============================================================
#  claude-deepseek.sh - run Claude Code against DeepSeek
#
#  Points Claude Code's Anthropic-compatible client at DeepSeek's
#  Anthropic-compatible endpoint, in an isolated config dir. Every model
#  slot - including the background "small/fast" model - is pinned, so no
#  request silently falls back to a different or cheaper tier.
#
#  Bring your own key: export DEEPSEEK_API_KEY, or put it in a .env file next to
#  this script. Nothing is hardcoded here.
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL="${DEEPSEEK_MODEL:-deepseek-v4-pro}"
export CLAUDE_CONFIG_DIR="$HOME/.claude-deepseek"

KEY="${DEEPSEEK_API_KEY:-}"
if [ -z "$KEY" ] && [ -f "$SCRIPT_DIR/.env" ]; then
  KEY="$(grep -m1 -E '^(export )?DEEPSEEK_API_KEY=' "$SCRIPT_DIR/.env" | cut -d= -f2- | tr -d '\r' | tr -d '\"')"
fi
if [ -z "$KEY" ]; then
  echo "[claude-deepseek] ERROR: DEEPSEEK_API_KEY not set."
  echo "  export it, or add DEEPSEEK_API_KEY=... to a .env next to this script."
  exit 1
fi

export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="$KEY"
export ANTHROPIC_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_OPUS_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_SONNET_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="$MODEL"
export CLAUDE_CODE_SUBAGENT_MODEL="$MODEL"
export ANTHROPIC_SMALL_FAST_MODEL="$MODEL"

echo "  ========================================"
echo "   claude-deepseek"
echo "   Backend: DeepSeek (api.deepseek.com/anthropic)"
echo "   Model:   $MODEL  (all slots)"
echo "   Config:  $CLAUDE_CONFIG_DIR"
echo "  ========================================"

# Add --dangerously-skip-permissions yourself to skip permission prompts.
exec claude --model opus "$@"
