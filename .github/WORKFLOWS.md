# Workflows

## Build Matrix

Runs on every push to `main` and on pull requests. Lints code with `swift-format` and builds the app on a matrix of simulators (iPhone 16/iOS 18, iPhone 17/iOS 26, iPhone 17 Pro Max/iOS 26). Acts as a quality gate — branch protection requires all checks to pass before merging.

## TestFlight

Builds, archives, and uploads the app to TestFlight. Triggered in two ways:

- **Repository dispatch** from [scout](https://github.com/kasianov-mikhail/scout) — when scout's tests pass on `main`, it sends a `scout-updated` event. The workflow deletes `Package.resolved`, re-resolves to pick up the latest scout commit, creates a PR with the update, and enables auto-merge.
- **Manual** via `workflow_dispatch`.

If App Store Connect rejects the version, the workflow automatically bumps the minor version via PR. On success, it tags the build.

## Debounce TestFlight

Triggers on push to `main`. Waits 15 minutes before calling the TestFlight workflow. If another push arrives during the wait, the previous run is cancelled and the timer resets. This batches rapid changes into a single TestFlight build. Skips the build if the daily upload limit has been reached.

## Auto Fix

Currently disabled. Designed to run Claude Code via `claude-code-action` when Build Matrix fails, diagnose the issue, and create a fix PR automatically.
