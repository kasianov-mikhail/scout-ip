# Workflows

## Build Matrix

Lints and builds the app on a matrix of simulators.
Required to pass before merging.

## TestFlight

Builds and uploads the app to TestFlight.
Triggered when the Scout package updates or manually.
Bumps the version automatically if App Store Connect rejects it.

## Debounce TestFlight

Waits 15 minutes after the last push to main, then triggers TestFlight.
Batches rapid changes into a single build.

## Auto Fix

Triggers when Build Matrix fails.
Runs Claude Code to diagnose the failure and create a fix PR.

## Resolve Conflicts

Triggers on push to main.
Finds open PRs with merge conflicts and runs Claude Code to resolve them.
