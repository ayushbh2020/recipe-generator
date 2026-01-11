#!/bin/bash
# Auto-format files after Edit/Write operations
# Handles the "last 10%" of formatting that Claude might miss

set -e

# Parse input JSON to get file path
FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# Exit if no file path (shouldn't happen, but be defensive)
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Exit if file doesn't exist
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Determine file extension
EXT="${FILE_PATH##*.}"
FORMATTED=false

# Format TypeScript/JavaScript files with Prettier
if [[ "$EXT" =~ ^(ts|tsx|js|jsx|json|css|scss|html|md|mdx)$ ]]; then
  if [ -x "$CLAUDE_PROJECT_DIR/node_modules/.bin/prettier" ]; then
    "$CLAUDE_PROJECT_DIR/node_modules/.bin/prettier" --write "$FILE_PATH" 2>/dev/null && FORMATTED=true
  fi
fi

# Format Python files with Black and Ruff
if [[ "$EXT" == "py" ]]; then
  # Try black first (formatting)
  if [ -x "$CLAUDE_PROJECT_DIR/venv/bin/black" ]; then
    "$CLAUDE_PROJECT_DIR/venv/bin/black" --quiet "$FILE_PATH" 2>/dev/null && FORMATTED=true
  fi

  # Then ruff (linting + auto-fix)
  if [ -x "$CLAUDE_PROJECT_DIR/venv/bin/ruff" ]; then
    "$CLAUDE_PROJECT_DIR/venv/bin/ruff" check --fix --silent "$FILE_PATH" 2>/dev/null || true
  fi
fi

# Report what was formatted (only in verbose mode)
if [ "$FORMATTED" = true ]; then
  echo "✓ Formatted: $FILE_PATH" >&2
fi

exit 0
