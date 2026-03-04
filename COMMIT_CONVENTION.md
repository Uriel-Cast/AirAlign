# Commit Convention Guidelines

To ensure a clean and readable project history, AirAlign uses **Conventional Commits**. This allows for automated changelog generation and easier project scaling.

## Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description |
| :--- | :--- |
| `feat` | A new feature for the user |
| `fix` | A bug fix for the user |
| `docs` | Changes to documentation |
| `style` | Formatting, missing semi colons, etc; no code change |
| `refactor` | Refactoring production code, eg. renaming a variable |
| `test` | Adding missing tests, refactoring tests; no production code change |
| `chore` | Updating build tasks, package manager configs, etc; no production code change |
| `perf` | Code change that improves performance |
| `ci` | Changes to CI configuration files and scripts |
| `build` | Changes that affect the build system or external dependencies |

### Examples

**Simple Feature:**
`feat: implementation of glassmorphism effect in LandingView`

**Fix with Scope:**
`fix(navigation): resolve TabView overlap on iPhone SE`

**Breaking Change:**
```
feat: transition to CloudKit for data persistence

BREAKING CHANGE: Local storage is no longer supported. Users must migrate data on first launch.
```

## Best Practices

1.  **Keep it concise**: The subject line should be under 50 characters if possible.
2.  **Use imperative mood**: "add feature" instead of "added feature" or "adds feature".
3.  **Atomic commits**: Commit small, logical units of work.
