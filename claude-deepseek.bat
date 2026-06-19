@echo off
REM ============================================================
REM  claude-deepseek.bat - run Claude Code against DeepSeek
REM
REM  Points Claude Code's Anthropic-compatible client at DeepSeek's
REM  Anthropic-compatible endpoint, in an isolated config dir so it does
REM  not touch your normal Claude Code setup. Every model slot - including
REM  the background "small/fast" model - is pinned, so no request silently
REM  falls back to a different or cheaper tier.
REM
REM  Bring your own key: set DEEPSEEK_API_KEY in your environment, or put it in a
REM  .env file next to this script. Nothing is hardcoded here.
REM ============================================================

if "%DEEPSEEK_MODEL%"=="" set "DEEPSEEK_MODEL=deepseek-v4-pro"
set "CLAUDE_CONFIG_DIR=%USERPROFILE%\.claude-deepseek"

set "PROVIDER_KEY=%DEEPSEEK_API_KEY%"
if "%PROVIDER_KEY%"=="" if exist "%~dp0.env" (
  for /f "usebackq tokens=1,* delims==" %%a in (`findstr /b "DEEPSEEK_API_KEY=" "%~dp0.env"`) do set "PROVIDER_KEY=%%b"
)
if "%PROVIDER_KEY%"=="" (
  echo [claude-deepseek] ERROR: DEEPSEEK_API_KEY not set.
  echo   Set it in your environment, or add DEEPSEEK_API_KEY=... to a .env next to this script.
  exit /b 1
)

set "ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic"
set "ANTHROPIC_AUTH_TOKEN=%PROVIDER_KEY%"
set "ANTHROPIC_MODEL=%DEEPSEEK_MODEL%"
set "ANTHROPIC_DEFAULT_OPUS_MODEL=%DEEPSEEK_MODEL%"
set "ANTHROPIC_DEFAULT_SONNET_MODEL=%DEEPSEEK_MODEL%"
set "ANTHROPIC_DEFAULT_HAIKU_MODEL=%DEEPSEEK_MODEL%"
set "CLAUDE_CODE_SUBAGENT_MODEL=%DEEPSEEK_MODEL%"
set "ANTHROPIC_SMALL_FAST_MODEL=%DEEPSEEK_MODEL%"

echo.
echo   ========================================
echo    claude-deepseek
echo    Backend: DeepSeek (api.deepseek.com/anthropic)
echo    Model:   %DEEPSEEK_MODEL%  (all slots)
echo    Config:  %CLAUDE_CONFIG_DIR%
echo   ========================================
echo.

REM Add --dangerously-skip-permissions yourself to skip permission prompts.
claude --model opus %*

set "CLAUDE_CONFIG_DIR="
set "ANTHROPIC_BASE_URL="
set "ANTHROPIC_AUTH_TOKEN="
set "ANTHROPIC_MODEL="
set "ANTHROPIC_DEFAULT_OPUS_MODEL="
set "ANTHROPIC_DEFAULT_SONNET_MODEL="
set "ANTHROPIC_DEFAULT_HAIKU_MODEL="
set "CLAUDE_CODE_SUBAGENT_MODEL="
set "ANTHROPIC_SMALL_FAST_MODEL="
set "PROVIDER_KEY="
