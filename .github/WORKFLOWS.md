# Workflows

## Build Matrix

Lints and builds the app on a matrix of simulators. Required to pass before merging.

## TestFlight

Builds and uploads the app to TestFlight. Triggered when the Scout package updates or manually. Automatically bumps the version if App Store Connect rejects it.

## Debounce TestFlight

Waits 15 minutes after the last push to main, then triggers TestFlight. Batches rapid changes into a single build.

## Auto Fix

Currently disabled. Runs Claude Code to diagnose and fix build failures automatically.
