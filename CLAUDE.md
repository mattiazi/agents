# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A curated collection of AI agent definition files for two platforms:

- **`claude/`** — Agents for Claude Code (`~/.claude/agents/`)
- **`codex/`** — Agents for OpenAI Codex (`~/.codex/agents/`)

Each agent is a single Markdown file with YAML frontmatter.

## Installing Agents

```bash
./install.sh
```

The script prompts for platform (Claude / Codex / Both) and which agents to install, then copies files to the appropriate platform directory. It skips platforms whose base directory (`~/.claude` or `~/.codex`) doesn't exist.

## Agent File Format

### Claude agents (`claude/*.md`)

```yaml
---
name: "Agent Name"
description: When/why to use this agent (shown in Claude Code UI)
tools: Read, Grep, Glob, Bash   # optional — restricts available tools
model: opus | sonnet | haiku
color: red | cyan | grey | ...  # optional
memory: user                     # optional — enables persistent memory
---
```

### Codex agents (`codex/*.md`)

```yaml
---
name: "Agent Name"
description: When/why to use this agent
model: gpt-5.4 | gpt-5.4-mini
---
```

The body is plain Markdown describing the agent's persona, rules, and required output format.

## Available Agents

Both platforms have identical agents (same behavior, different model names):

| Agent | Purpose |
|---|---|
| `tech-lead` | Orchestrator — breaks tasks into sub-agent assignments, never writes code itself |
| `go-engineer` | Go backend implementation, clean/hexagonal architecture |
| `react-component-architect` | React components, hooks, modern patterns |
| `vue-component-architect` | Vue 3 Composition API components |
| `laravel-engineer` | Laravel backend, Eloquent, API resources |
| `tailwind-css-expert` | Tailwind styling and responsive UI |
| `api-designer` | RESTful API design and OpenAPI specs |
| `security-engineer` | Auth flows, security reviews, sensitive data |
| `code-reviewer` | Post-feature quality gate with severity-tagged report |
| `documentation-specialist` | READMEs, API specs, architecture guides |
| `database-architect` | Schema design, migrations, query optimization |

## Key Conventions

- Every agent prefixes all output with `[Agent Name]` on the first line.
- The `tech-lead` agent never implements code — it only delegates to sub-agents with a strict format; max 2 agents run in parallel.
- Claude agents that set `memory: user` maintain persistent memory across conversations at `~/.claude/agent-memory/<agent-name>/`.
- When adding a new agent, create the file in both `claude/` and `codex/` with appropriate model names for each platform.

## Model Name Mapping

| Claude | Codex |
|---|---|
| `opus` | `gpt-5.4` |
| `sonnet` | `gpt-5.4` |
| `haiku` | `gpt-5.4-mini` |
