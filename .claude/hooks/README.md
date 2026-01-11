# Claude Code Hooks

This directory contains hooks that enhance the Claude Code workflow.

## Permission Handler Hook

**File:** `permission-handler.sh`
**Type:** `PermissionRequest`
**Purpose:** Auto-approve or deny tool permissions based on safety rules for hands-free workflows.

### How It Works

The permission handler evaluates each tool request and responds with:

- `allow` - Auto-approve the operation
- `deny: <reason>` - Block the operation with a reason
- `ask: <reason>` - Require manual approval

### Auto-Approved Tools

**Always Safe:**

- `Read`, `Glob`, `Grep` - File reading and searching
- `WebFetch`, `WebSearch` - Web operations

**File Operations (`Write`, `Edit`):**

- ✅ Files within project directory
- ❌ Sensitive files (`.env`, `.ssh/`, `credentials`, `secrets`, system paths)

**Bash Commands:**

- ✅ Read-only git commands (`git status`, `git diff`, `git log`)
- ✅ Common dev tools (`npm install`, `pnpm install`, `pip install`, `pytest`)
- ✅ Git operations (`git add`, `git commit`, `git push`)
- ❌ Destructive commands (`rm -rf`, `dd`, `chmod -R`, curl/wget piped to shell)
- ⚠️ Other commands require manual review

### Customization

Edit `permission-handler.sh` to adjust rules:

```bash
# Add more safe tools
case "$TOOL_NAME" in
  "Read"|"Glob"|"YourCustomTool")
    echo "allow"
    exit 0
    ;;
esac

# Add more safe command patterns
if [[ "$COMMAND" =~ ^your-safe-command ]]; then
  echo "allow"
  exit 0
fi
```

### Return Codes

- `0` - Allow (outputs "allow")
- `1` - Deny (outputs "deny: <reason>")
- `2` - Ask user (outputs "ask: <reason>")

## Auto-Format Hook

**File:** `auto-format.sh`
**Type:** `PostToolUse`
**Purpose:** Automatically formats code after Edit/Write operations.

Runs Prettier for JS/TS files and Black for Python files.

## Notify on Stop Hook

**File:** `notify-on-stop.sh`
**Type:** `Stop`
**Purpose:** Sends notifications when Claude Code stops/completes tasks.
