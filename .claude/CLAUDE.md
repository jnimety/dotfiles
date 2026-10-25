# Global Claude Code Instructions

## Conventions

- Use `jq` for JSON parsing, not `python3 -m json.tool` or other Python-based approaches.
- Use `yq` for YAML parsing, not Python or other approaches.
- Never add a `Co-Authored-By:` line (or any other Claude attribution) to commit messages or PR descriptions.
- The Bash tool runs zsh, so write tool commands in zsh/POSIX syntax. This laptop's login shell is fish: commands for the user to paste into their own terminal must be written for fish or explicitly invoke bash (e.g. `bash -c '...'`).

## Commits

- Don't run `git commit` or `git push` unless the user asks for it in the current task (e.g. "commit as you go", "commit in logical chunks"). Authorization is per task, never standing. Otherwise do the work, run the tests, and stop; suggest a commit message if useful.
- When committing: lowercase imperative subject, body explains why. Use `git commit -- <paths>` so anything else the user has staged stays out.
- To split one file's changes across commits without touching the working tree: write the partial version to the scratchpad, `git hash-object -w` it, and stage the blob with `git update-index --cacheinfo 100644,<blob>,<path>`.
- Follow each repo's branching rules (see its AGENTS.md); repos without git flow commit straight to their main branch with subjects matching that repo's history.

## Formatting

Format structured code before writing it to a file or showing it in a response. Hooks format `Write`/`Edit` output (.md/.sql/.tf/.yaml) and Bash-made .md edits; format Bash-made .sql/.tf/.yaml edits and code shown in chat by hand:

| Language      | Command                                                     |
| ------------- | ----------------------------------------------------------- |
| SQL           | `~/.local/share/nvim/mason/bin/sql-formatter`               |
| Terraform/HCL | `/opt/homebrew/bin/terraform fmt -`                         |
| YAML          | `~/.local/share/nvim/mason/bin/yamlfmt -`                   |
| Markdown      | `~/.local/share/nvim/mason/bin/prettierd --parser markdown` |

Format files even when they weren't formatter-clean before; the user reviews such diffs with `git diff -w`.

## SQL

- Don't use table aliases; write full table names (`users.id`, not `u.id`). The only exception is when a self-join or other ambiguity makes aliases unavoidable.
