---
name: atomic-commit
description: "Create atomic, conventional-git-commits. Analyzes staged changes, classifies them by type (feat/fix/refactor/docs/test/chore/etc.), suggests commit messages, and helps split large changesets into logical units. Use this skill whenever the user wants to commit code, stage changes, write commit messages, split commits, review diffs before committing, or mentions 'git commit', 'conventional commit', 'atomic commit', '提交', 'commit message'. Avoids all destructive git commands."
tags: [git, commit, workflow, code-quality]
---

# Atomic Commit

A skill for creating clean, atomic, conventional git commits. It analyzes your
staged changes, classifies the type of modification, suggests a well-formed
commit message, and helps split large changesets into logical single-concern
commits.

## Core Principles

1. **One commit = one logical change.** Don't mix feature work with bug fixes or
   formatting.
2. **Commit messages are documentation.** A good message tells a future reader
   _what_ changed and _why_.
3. **Never destroy work.** Avoid destructive commands; always preserve the
   ability to recover.
4. **Each commit is a safe checkpoint.** The codebase must be in a working state
   after every single commit.
5. **Commits tell a story in order.** The sequence is logically ordered —
   prerequisites first, dependents later. Each commit builds on the previous
   one.

## Continuity — Logical Commit Ordering

When splitting into multiple commits, order matters. The sequence must be
**dependency-aware**: each commit builds on the ones before it, and the codebase
is coherent at every step.

### Ordering Rules

1. **Foundation first.** Interfaces, types, schemas, configs, and shared
   utilities go in early commits. Concrete implementations follow.
2. **Additive before transformative.** Add new code/files before modifying
   existing code that references them. This avoids broken references
   mid-history.
3. **Non-breaking before breaking.** Introduce the new API alongside the old one
   first, then migrate callers, then deprecate the old one — each in separate
   commits.
4. **Dependencies in topological order.** If module A depends on module B,
   commit B first.

### Example: Adding a New Feature with DB Migration

```
Bad order (breaks at each step):
  1. feat(api): use new User.email field        ← DB column doesn't exist yet
  2. feat(db): add email column to users table   ← too late

Good order (each step works):
  1. feat(db): add email column to users table   ← additive, no breakage
  2. feat(api): populate and read User.email     ← column exists now
  3. test(api): add tests for email field         ← feature is complete
```

### Continuity Checklist

Before finalizing the commit sequence, verify mentally (or with `git stash` +
test):

- [ ] After commit N, does the code compile/build?
- [ ] After commit N, do existing tests still pass (if applicable)?
- [ ] Does commit N+1 reference anything introduced in commit N? (If yes, order
      is correct)
- [ ] Is the narrative clear? Could someone `git log --oneline` through it and
      understand the story?

---

## Rollback — Every Commit is Revertable

Each commit must be independently revertable via `git revert <sha>` without
breaking the codebase. This is non-negotiable — it's your safety net.

### What Makes a Commit Revertable

A commit is revertable when `git revert` on it produces a working codebase. This
means:

1. **No forward references to unreleased changes.** If commit B depends on
   commit A, reverting A while keeping B would break things. Solution: make B
   self-contained or group A+B as one commit.
2. **Backward-compatible database changes.** Schema changes must be applied in
   two phases:
   - **Phase 1 (expand):** Add new column/table (old code ignores it) —
     `feat(db): add email column`
   - **Phase 2 (migrate):** Start using the new column —
     `feat(api): populate User.email`
   - **Phase 3 (contract):** Remove old column (only after all code uses new
     one) — `chore(db): drop legacy name column`
   - Reverting Phase 2 or 3 is safe; reverting Phase 1 is safe too (column
     disappears, old code never used it).
3. **Additive API changes.** New endpoints, new fields, new optional parameters
   — these are safe to revert. Renaming/removing existing fields is not
   revertable without coordination.
4. **Feature flags for risky changes.** If a commit introduces behavior that
   might need instant rollback, gate it behind a feature flag. The flag toggle
   is a separate commit.

### Rollback-Unfriendly Patterns (Avoid)

| Pattern                                  | Problem                               | Fix                                             |
| ---------------------------------------- | ------------------------------------- | ----------------------------------------------- |
| Rename a column in one commit            | Old code breaks immediately on revert | Add new column → migrate → drop old (3 commits) |
| Delete code that other commits depend on | Later commits break on revert         | Delete last, after all dependents are removed   |
| Mix migration + code change              | Can't revert one without the other    | Split into: migration commit → code commit      |
| Introduce + immediately remove a feature | Meaningless commit, confusing history | Don't commit throwaway work                     |
| Amend previous commit after pushing      | Rewrites shared history               | Use `fixup!` commits instead                    |

### Rollback Safety Check

After suggesting a commit sequence, mentally simulate reverting each commit in
reverse order:

```
Revert commit 3 (test)     → still works, just missing tests ✓
Revert commit 2 (feat)     → still works, feature gone, DB column untouched ✓
Revert commit 1 (db)       → still works, column gone, code never used it ✓
```

If any revert would break the codebase, restructure the commits until all
reverts are safe.

---

## Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) spec:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

| Type       | When to use                                          |
| ---------- | ---------------------------------------------------- |
| `feat`     | A new feature or capability                          |
| `fix`      | A bug fix                                            |
| `docs`     | Documentation only changes                           |
| `style`    | Formatting, whitespace, semicolons — no logic change |
| `refactor` | Code restructuring without behavior change           |
| `perf`     | Performance improvement                              |
| `test`     | Adding or updating tests                             |
| `build`    | Build system or external dependency changes          |
| `ci`       | CI/CD configuration changes                          |
| `chore`    | Maintenance tasks, tooling, no src/test change       |
| `revert`   | Reverts a previous commit                            |

### Rules

- **Subject line**: imperative mood, lowercase, no period, max 72 chars
  - ✓ `feat(auth): add JWT token refresh`
  - ✓ `fix: prevent null pointer in user lookup`
  - ✗ `Fixed the bug` / `Add feature.` / `FIXED THE BUG`
- **Body** (optional): explain _why_, not _what_ (the diff shows what). Wrap at
  72 chars.
- **Scope**: module/area affected, e.g. `(api)`, `(ui)`, `(auth)`. Optional but
  helpful.
- **Footer**: reference issue numbers: `Closes #123`, `Fixes #456`

## Workflow

### Step 1: Assess the Current State

Run these commands to understand what's staged and what's not:

```bash
git status
git diff --staged --stat
git diff --stat          # unstaged changes (if any)
```

If nothing is staged, tell the user and ask whether to stage specific files or
all changes. **Never** `git add -A` or `git add .` without explicit confirmation
— these can stage secrets, build artifacts, or generated files.

### Step 2: Analyze the Staged Diff

Read the full staged diff to understand what changed:

```bash
git diff --staged
```

Classify the changes:

1. **File-level**: which files changed? Group by directory/module.
2. **Change-level**: for each file, what kind of change?
   - New files → likely `feat` or `test`
   - Deleted files → likely `chore` or `revert`
   - Modified logic → likely `fix` or `refactor`
   - Modified comments/docs only → likely `docs`
   - Whitespace/formatting only → likely `style`
   - Config/build files → likely `build`, `ci`, or `chore`
   - Test files only → likely `test`
3. **Scope**: what module/area do the changes span?

### Step 3: Decide — Single Commit or Split?

**Single commit** is appropriate when:

- All changes serve one purpose (e.g., "add user login")
- Files are logically related
- The diff is small and coherent (< ~300 lines)

**Split into multiple commits** when:

- Changes serve different purposes (e.g., refactor + new feature)
- Unrelated files are mixed together
- Some changes are prerequisites for others (dependency order matters)
- The diff is large and covers multiple concerns

When splitting, follow these rules:

1. **Order by dependency** — foundation (types, schemas, configs) →
   implementation → tests → docs
2. **Each commit must compile and pass tests** — no "works only with the next
   commit" hacks
3. **Each commit must be independently revertable** — if reverting commit N
   breaks commit N+1, they should be merged or reordered
4. **Suggest a commit plan** like:

```
Commit 1: feat(db): add email column to users table
Commit 2: feat(api): populate and read User.email
Commit 3: test(api): add tests for email field
Commit 4: docs(api): update API documentation for email field
```

5. **Simulate reverts** before finalizing — mentally (or with `git stash` +
   test) verify that reverting any single commit leaves the codebase working

### Step 4: Suggest the Commit Message

Present the suggested message to the user. Format:

```
Suggested commit message:

  feat(auth): add JWT token refresh

  Implement automatic token refresh when the access token expires.
  The refresh happens transparently before API calls.

  Closes #42
```

Ask the user if they want to adjust. Accept their edits without resistance.

### Step 5: Execute Safely

For each atomic commit:

```bash
# Stage only the files for this commit
git add <specific files>

# Commit with the message
git commit -m "type(scope): description" -m "body paragraph"
```

**Never use these commands without explicit user confirmation:**

| Command                              | Why it's dangerous                                 |
| ------------------------------------ | -------------------------------------------------- |
| `git reset --hard`                   | Discards all working tree changes permanently      |
| `git push --force`                   | Overwrites remote history, destroys others' work   |
| `git push --force-with-lease`        | Still dangerous on shared branches — confirm first |
| `git clean -f`                       | Permanently deletes untracked files                |
| `git checkout -- .`                  | Discards all unstaged changes                      |
| `git stash drop`                     | Removes stashed changes                            |
| `git branch -D`                      | Force-deletes a branch (use `-d` for safe delete)  |
| `git rebase` on shared branches      | Rewrites shared history                            |
| `git push` to main/master without PR | Bypasses code review                               |

If a destructive command is genuinely needed, always:

1. Explain what it does and what will be lost
2. Suggest a safer alternative (e.g., `git stash` instead of discard)
3. Wait for explicit confirmation before executing

### Step 6: Verify

After committing, confirm success:

```bash
git log --oneline -5
```

Show the user the result. If splitting, show the full commit sequence.

## Handling Special Cases

### Database Migrations

Schema changes are the #1 source of non-revertable commits. Always follow the
**expand/contract** pattern:

```
1. feat(db): add users.email column (nullable, no default)    ← expand
2. feat(api): start reading/writing users.email                ← migrate
3. chore(db): drop users.name column after migration           ← contract (separate PR/commit)
```

- Never rename a column in one commit — add new + drop old is two commits
- Never change a column type in one commit — add new column of new type →
  migrate data → drop old
- Nullable columns first, constraints later

### Amend / Fixup After Push

If you need to fix the previous commit after pushing:

```bash
# Instead of git commit --amend + force push:
git commit --fixup=<previous-sha>
git rebase --autosquash
```

This preserves history and avoids `--force`. Only rebase local/unpushed commits.

### Merge Conflicts During Commit

Don't force through. Suggest:

1. `git stash` the current work
2. Resolve conflicts carefully
3. Re-apply with `git stash pop`

### Detached HEAD

Warn immediately. Suggest creating a branch:

```bash
git switch -c <branch-name>
```

### Large Binary Files

Warn that these bloat the repo. Suggest `.gitattributes` with Git LFS if
appropriate.

### Secrets in Diff

If the staged diff contains API keys, passwords, or tokens:

1. **STOP** — do not commit
2. Show the user which file contains the secret
3. Suggest adding to `.gitignore` and rotating the exposed credential
4. Help remove the secret from the file and stage the fix

## Example Interaction

**User**: "帮我提交一下"

**Agent**:

1. Runs `git status` and `git diff --staged --stat`
2. Finds nothing staged → "当前没有暂存的更改。你想提交哪些文件？"
3. User says "all the changes in src/"
4. Agent runs `git add src/` then `git diff --staged`
5. Analyzes: new `auth.py` module + modified `api.py` + new `test_auth.py`
6. Orders by dependency and suggests split:
   ```
   Commit 1: feat(auth): add authentication module
            → DB schema change is additive, old code unaffected ✓
   Commit 2: feat(api): integrate auth into API endpoints
            → depends on commit 1, additive to existing endpoints ✓
   Commit 3: test(auth): add unit tests for authentication
            → pure addition, reverting loses tests but code still works ✓
   ```
7. Simulates reverts:
   - Revert 3 → code works, just missing tests ✓
   - Revert 2 → code works, auth module exists but isn't wired in ✓
   - Revert 1 → code works, module gone, API never referenced it ✓
8. Executes each commit after user confirms
9. Shows `git log --oneline -5` with the three new commits
