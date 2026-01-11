# Create Command

You are given the following context:
$ARGUMENTS

## Instructions

Your task is to create a new custom command that we can use with Claude Code.

Anytime you are asked to create a new command, create it at the following path:

```
.claude/commands/
  - <command-name>.md
```

Please format the command as follows:

```
# <command-name>

You are given the following context:
$ARGUMENTS

<command-here>
```

## Guidelines

- Command names should be lowercase with hyphens (e.g., `review-code`, `add-tests`)
- Keep instructions clear and specific
- Use `$ARGUMENTS` to accept user input when the command is invoked
- Commands should be focused on a single task or workflow
