# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a hybrid Next.js + Python (FastAPI) application demonstrating the Vercel AI SDK's Data Stream Protocol for streaming chat completions. The Next.js frontend uses the `useChat` hook from `@ai-sdk/react` to communicate with a Python FastAPI backend that streams responses from OpenAI.

## Development Commands

```bash
# Install dependencies
pnpm install                    # Node dependencies
pip install -r requirements.txt # Python dependencies (in virtualenv)

# Development (runs both Next.js and FastAPI concurrently)
pnpm dev

# Run only Next.js frontend
pnpm next-dev

# Run only FastAPI backend
pnpm fastapi-dev

# Build for production
pnpm build

# Lint
pnpm lint

# Type-check the codebase without emitting files
npx tsc --noEmit
```

## Environment Setup

Create a `.env` file based on `.env.local` format. The API uses Vercel OIDC for authentication with OpenAI via the Vercel AI Gateway (`https://ai-gateway.vercel.sh/v1`).

## Skills

When @.claude/skills is mentioned or when starting a task:

1. Read .claude/skills/CLAUDE.md
2. Scan the index for relevant skills
3. Mention which skills you're referencing
4. Note any deviations from the skill pattern and why
5. Suggest new skills when you see repeated patterns (use `.claude/commands/create-skill.md` to create a new skill)

## Architecture

### Frontend (Next.js)

- `app/(chat)/page.tsx` - Main chat page using the `Chat` component
- `components/chat.tsx` - Core chat UI using `useChat` hook from `@ai-sdk/react`
- `components/message.tsx` - Message rendering components
- `components/multimodal-input.tsx` - Input handling with attachment support

### Backend (FastAPI)

- `api/index.py` - FastAPI app with `/api/chat` POST endpoint
- `api/utils/stream.py` - SSE streaming implementation following Vercel AI SDK Data Stream Protocol
- `api/utils/prompt.py` - Converts client messages to OpenAI format, handles tool invocations
- `api/utils/tools.py` - Tool definitions (e.g., `get_current_weather`) and registry

### Request Flow

1. Frontend sends messages to `/api/chat` via `useChat` hook
2. Next.js rewrites `/api/*` to FastAPI server (port 8000 in development)
3. FastAPI converts messages to OpenAI format and streams responses using SSE
4. Stream events follow Vercel AI SDK protocol: `start`, `text-start`, `text-delta`, `text-end`, `tool-*`, `finish`

### Key Patterns

- Tool calls are handled server-side in `stream.py` with results streamed back
- Message parts support text, files/images, and tool invocations
- The `patch_response_with_headers` function adds required Vercel AI SDK headers
