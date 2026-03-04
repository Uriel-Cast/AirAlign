# Contributing to AirAlign

Thank you for contributing! To maintain a scalable and professional codebase, we follow a strict branching model and commit convention.

## Branching Model

We use a GitFlow-inspired model:

-   `main`: Production branch. Only contains stable, released code.
-   `develop`: Integration branch. All features and bug fixes are merged here for testing before release.
-   `feature/*`: Feature branches. Created from `develop`, merged back to `develop`.
-   `fix/*`: Bug fix branches. Created from `develop`, merged back to `develop`.
-   `hotfix/*`: Critical production fixes. Created from `main`, merged back to both `main` and `develop`.

## Conventional Commits

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification. Each commit message must start with a type:

-   `feat`: A new feature.
-   `fix`: A bug fix.
-   `docs`: Documentation changes.
-   `style`: Formatting, missing semi-colons, etc (no code changes).
-   `refactor`: Refactoring production code.
-   `test`: Adding tests, refactoring tests.
-   `chore`: Updating build tasks, package manager configs, etc.

Example: `feat: add real-time posture calibration`

## Workflow

1.  Create a branch from `develop`: `git checkout -b feature/my-new-feature develop`.
2.  Commit changes using Conventional Commits.
3.  Push your branch: `git push origin feature/my-new-feature`.
4.  Open a Pull Request to merge into `develop`.
