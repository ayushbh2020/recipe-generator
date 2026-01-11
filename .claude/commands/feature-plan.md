# Feature Plan

Plan the implementation for: $ARGUMENTS

## Instructions

1. Analyze the feature request and identify which parts of the codebase will be affected
2. Consider both frontend (Next.js/React) and backend (FastAPI/Python) changes
3. If the feature involves streaming or AI responses, review `api/utils/stream.py` for the Data Stream Protocol
4. If adding new tools, check `api/utils/tools.py` for the existing pattern
5. Break down the implementation into concrete steps
6. Identify any new dependencies or environment variables needed
7. Note any potential impacts on the existing chat flow

Output a structured plan with into a plan.md document:

- Summary of changes needed
- Files to create or modify
- Step-by-step implementation order
- Any questions or clarifications needed before starting
