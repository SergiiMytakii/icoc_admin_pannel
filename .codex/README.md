# Repo-Scoped Codex

This folder is the git-safe Codex snapshot for this repository.

It exists so the project keeps:

- repo-specific Codex memory
- notebook routing rules
- skill snapshots that matter for this project
- operational notes that should survive outside one local machine

## Why This Exists

The full home folder `~/.codex` should not be committed to git.

That global folder may contain:

- auth state
- local SQLite databases
- archived sessions
- logs
- `.env` files
- personal automations
- machine-specific runtime state

Those files are useful locally, but they are the wrong thing to version in a shared repo.

## What Belongs Here

Only commit repo-relevant and git-safe Codex assets, such as:

- skill snapshots
- memory and routing docs
- runbooks
- stable prompts

## What Must Not Be Committed Here

Do not add:

- secrets
- tokens
- browser state
- auth files
- local databases
- session archives
- logs
- personal `.env` files

## Current Usage

This repo currently stores:

- a snapshot of the NotebookLM orchestrator skill used for `insights`
- notebook routing rules for the multi-notebook content workflow

The authoritative operational playbook for the content system is still:

- [insights-content-automation.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/docs/insights-content-automation.md)
