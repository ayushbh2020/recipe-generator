#!/bin/bash
# Notification hook for Stop event
# Plays sound, shows desktop notification, and optionally sends webhook alerts

set -e

# Parse input JSON
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
PERMISSION_MODE=$(echo "$INPUT" | jq -r '.permission_mode // "default"')

# Notification message
MESSAGE="Claude Code finished"
if [ "$PERMISSION_MODE" = "plan" ]; then
  MESSAGE="Claude Code planning complete"
fi

# 1. Play sound on macOS
if command -v afplay &> /dev/null; then
  # Use system sound (Glass is a nice completion sound)
  afplay /System/Library/Sounds/Glass.aiff &>/dev/null &
fi

# 2. Show macOS desktop notification
if command -v osascript &> /dev/null; then
  osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\" sound name \"Glass\"" &>/dev/null 2>&1 &
fi

# 3. Flash terminal title (works in most terminals)
echo -ne "\033]0;✅ Claude Code Done\007" >&2

# 4. Optional: Send webhook notification
# Uncomment and configure if you want Slack/Discord/webhook alerts
if [ -n "$CLAUDE_WEBHOOK_URL" ]; then
  WEBHOOK_PAYLOAD=$(cat <<EOF
{
  "text": "$MESSAGE",
  "session_id": "$SESSION_ID",
  "mode": "$PERMISSION_MODE"
}
EOF
)

  curl -s -X POST "$CLAUDE_WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d "$WEBHOOK_PAYLOAD" &>/dev/null &
fi

# 5. Optional: Send Slack notification
if [ -n "$SLACK_WEBHOOK_URL" ]; then
  SLACK_PAYLOAD=$(cat <<EOF
{
  "text": "✅ $MESSAGE",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Claude Code Finished*\n\`$SESSION_ID\` completed in \`$PERMISSION_MODE\` mode"
      }
    }
  ]
}
EOF
)

  curl -s -X POST "$SLACK_WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d "$SLACK_PAYLOAD" &>/dev/null &
fi

# Print message to stderr (visible in verbose mode)
echo "🔔 Notification sent: $MESSAGE" >&2

exit 0
