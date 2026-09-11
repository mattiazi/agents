# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A curated collection of AI agent definition files for Claude Code. Each agent lives in `claude/` as a single Markdown file with YAML frontmatter and installs to `~/.claude/agents/`.

## Installing Agents

```bash
./install.sh
```

The script lists the agents in `claude/`, prompts for which to install (Enter selects all), and copies them to `~/.claude/agents/`. It aborts if `~/.claude` doesn't exist.

## Agent File Format

```yaml
---
name: "Agent Name"
description: When/why to use this agent (shown in Claude Code UI)
tools: Read, Grep, Glob, Bash   # optional — restricts available tools
model: opus | sonnet | haiku
color: red | cyan | grey | ...  # optional
memory: user | project           # optional — enables persistent memory
---
```

The body is plain Markdown describing the agent's persona, rules, and required output format.

## Available Agents

Agents that declare a `memory:` field also carry a `# Persistent Agent Memory` protocol section in their body.

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
- Agents with a `memory:` field maintain persistent memory across conversations at `~/.claude/agent-memory/<agent-name>/` (`user` = general learnings, `project` = codebase-specific).
- When adding a new agent, create the file in `claude/` — `install.sh` picks it up automatically.
