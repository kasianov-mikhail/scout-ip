## 🧪 Build Matrix

Lints and builds the app on a matrix of simulators.
Required to pass before merging.

## 📦 Update Scout

Triggers on repository_dispatch from scout.
Updates Package.resolved to the latest scout commit and merges via PR.

## 🚀 TestFlight

Builds and uploads the app to TestFlight.
Triggered by Debounce TestFlight or manually.
Bumps the version automatically if App Store Connect rejects it.

## ⏳ Debounce TestFlight

Waits 15 minutes after the last push to main, then triggers TestFlight.
Batches rapid changes into a single build.
