# open-pr

You are given the following context:
$ARGUMENTS

## Instructions

Create a new pull request on GitHub for the current branch. Follow these steps:

1. Check the current git status and branch
2. Ensure all changes are committed
3. Push the current branch to remote if needed
4. Create a pull request using the GitHub CLI (`gh pr create`)
5. Use the provided arguments as the PR title and description, or generate appropriate ones based on the recent commits
6. Return the PR URL after creation

If no arguments are provided, analyze the recent commits to generate an appropriate PR title and description.
