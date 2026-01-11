#!/bin/bash

# Permission Request Hook
# Auto-approves or denies tool permissions based on safety rules

# Get tool name and parameters from stdin
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName // empty')
PARAMS=$(echo "$INPUT" | jq -r '.parameters // empty')

# Safe tools - auto-approve
case "$TOOL_NAME" in
  "Read"|"Glob"|"Grep"|"WebFetch"|"WebSearch")
    echo "allow"
    exit 0
    ;;
esac

# Safe file operations - auto-approve writes to project files
if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
  FILE_PATH=$(echo "$PARAMS" | jq -r '.file_path // empty')

  # Block sensitive files
  if [[ "$FILE_PATH" =~ \.env$ ]] || \
     [[ "$FILE_PATH" =~ \.env\.local$ ]] || \
     [[ "$FILE_PATH" =~ /etc/ ]] || \
     [[ "$FILE_PATH" =~ ^/System/ ]] || \
     [[ "$FILE_PATH" =~ \.ssh/ ]] || \
     [[ "$FILE_PATH" =~ credentials ]] || \
     [[ "$FILE_PATH" =~ secrets ]]; then
    echo "deny: Blocked modification of sensitive file: $FILE_PATH"
    exit 1
  fi

  # Allow writes within project directory
  if [[ "$FILE_PATH" == "$CLAUDE_PROJECT_DIR"* ]]; then
    echo "allow"
    exit 0
  fi
fi

# Bash commands - evaluate risk
if [[ "$TOOL_NAME" == "Bash" ]]; then
  COMMAND=$(echo "$PARAMS" | jq -r '.command // empty')

  # Block destructive commands
  if [[ "$COMMAND" =~ rm\ -rf ]] || \
     [[ "$COMMAND" =~ rm\ -fr ]] || \
     [[ "$COMMAND" =~ dd\ if= ]] || \
     [[ "$COMMAND" =~ format ]] || \
     [[ "$COMMAND" =~ mkfs ]] || \
     [[ "$COMMAND" =~ \>\ /dev/ ]] || \
     [[ "$COMMAND" =~ curl.*\|.*bash ]] || \
     [[ "$COMMAND" =~ wget.*\|.*sh ]] || \
     [[ "$COMMAND" =~ chmod\ -R ]] || \
     [[ "$COMMAND" =~ chown\ -R ]]; then
    echo "deny: Blocked potentially destructive command: $COMMAND"
    exit 1
  fi

  # Auto-approve safe read-only and common dev commands
  if [[ "$COMMAND" =~ ^git\ status ]] || \
     [[ "$COMMAND" =~ ^git\ diff ]] || \
     [[ "$COMMAND" =~ ^git\ log ]] || \
     [[ "$COMMAND" =~ ^git\ branch ]] || \
     [[ "$COMMAND" =~ ^npm\ (install|ci|run|test) ]] || \
     [[ "$COMMAND" =~ ^pnpm\ (install|run|test) ]] || \
     [[ "$COMMAND" =~ ^yarn\ (install|run|test) ]] || \
     [[ "$COMMAND" =~ ^pip\ install ]] || \
     [[ "$COMMAND" =~ ^pytest ]] || \
     [[ "$COMMAND" =~ ^ls ]] || \
     [[ "$COMMAND" =~ ^cat ]] || \
     [[ "$COMMAND" =~ ^echo ]] || \
     [[ "$COMMAND" =~ ^pwd ]]; then
    echo "allow"
    exit 0
  fi

  # Auto-approve git commits and pushes (assuming user wants these)
  if [[ "$COMMAND" =~ ^git\ (add|commit|push) ]]; then
    echo "allow"
    exit 0
  fi

  # For other commands, ask for manual approval
  echo "ask: Command requires review: $COMMAND"
  exit 2
fi

# Default: ask for manual approval for unknown tools
echo "ask: Tool requires review: $TOOL_NAME"
exit 2
