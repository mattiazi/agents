# agents

A curated collection of AI agent definitions for **Claude Code**. Drop them into `~/.claude/agents/` to get a team of specialized sub-agents that collaborate on complex development tasks.

## Installation

```bash
./install.sh
```

The installer lists the available agents, lets you pick which ones you want (Enter installs all), and copies them to `~/.claude/agents/`. It aborts if `~/.claude` doesn't exist.

## Agents

### Orchestration

| Agent | Description |
|---|---|
| **tech-lead** | Breaks any multi-step task into sub-agent assignments. Never writes code itself — only delegates. Enforces a structured output format and limits parallel execution to 2 agents at a time. |

### Backend

| Agent | Description |
|---|---|
| **go-engineer** | Idiomatic Go: clean/hexagonal architecture, error handling, concurrency, table-driven tests. Preferred libs: chi/gin, pgx, sqlc, zap/slog. |
| **laravel-engineer** | Laravel: controllers, Eloquent models, migrations, Form Requests, Policies, Jobs, Events, API Resources. |
| **database-architect** | PostgreSQL schema design, indexing strategy, migrations, full-text search, query optimization. |
| **api-designer** | RESTful API contracts: URL structure, HTTP methods, status codes, request/response shape, pagination, OpenAPI 3.x. |

### Frontend

| Agent | Description |
|---|---|
| **react-component-architect** | React 19 + Next.js 14 App Router, RSC, Tailwind CSS, shadcn/ui, Radix UI. |
| **vue-component-architect** | Vue 3 Composition API, scalable component architecture, modern Vue tooling. |
| **tailwind-css-expert** | Tailwind styling, utility-first refactors, responsive design. |

### Quality & Security

| Agent | Description |
|---|---|
| **code-reviewer** | Post-feature quality gate. Produces a severity-tagged report (🔴 Critical / 🟡 Major / 🟢 Minor) with file:line references and concrete fixes. |
| **security-engineer** | Auth flows, sensitive data handling, security headers, access control, input validation. |

### Documentation

| Agent | Description |
|---|---|
| **documentation-specialist** | READMEs, API specs, architecture guides, onboarding docs. |

## How Agents Work Together

The typical workflow when using **tech-lead** as the entry point:

```
tech-lead
  ├── analyzes the requirement
  ├── assigns every task to a named sub-agent
  └── specifies execution order (max 2 in parallel)
       ├── go-engineer      ← backend implementation
       ├── api-designer     ← API contract
       ├── react-component-architect ← frontend
       └── code-reviewer    ← final quality gate
```

Each agent prefixes all output with `[Agent Name]` so you can always tell which agent is responding.

## Adding a New Agent

1. Create `claude/<agent-name>.md` with the frontmatter below.
2. Run `./install.sh` to deploy.

### Frontmatter reference

```yaml
---
name: "Agent Name"
description: When and why to invoke this agent
tools: Read, Grep, Glob, Bash   # optional
model: opus | sonnet | haiku
color: red | cyan | grey | ...  # optional
memory: user | project          # optional
---
```
