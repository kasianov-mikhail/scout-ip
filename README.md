# Scout IP

A companion app for the [Scout](https://github.com/kasianov-mikhail/scout) package. Scout IP uses your device's public IP address to generate real-world logs, metrics, and activity data — providing a live environment to test and verify Scout's features through its built-in dashboard.

## Table of Contents
- [Features](#features)
- [Setup](#setup)
- [App Store](#app-store)
- [CI/CD](#cicd)
- [License](#license)

## Features

| | | |
|:-:|-|-|
| 🌐 | **IP Lookup** | Fetches public IP info via [ipinfo.io](https://ipinfo.io) and logs the results using Scout. |
| 📝 | **Live Logging** | Every lookup generates structured logs with metadata (IP, location, ISP) synced to CloudKit. |
| 📊 | **Metrics** | Tracks API request counts and response times via swift-metrics. |
| 📱 | **Dashboard** | Browse logs, metrics, crashes, and activity through Scout's built-in SwiftUI dashboard. |

## Setup

1. Clone the repository:
    ```sh
    git clone https://github.com/kasianov-mikhail/scout-ip.git
    ```
2. Copy the secrets template and fill in your API key:
    ```sh
    cp Secrets.xcconfig.template Secrets.xcconfig
    ```
3. Get your token from [ipinfo.io/account/token](https://ipinfo.io/account/token) and set it in `Secrets.xcconfig`.
4. Open `ScoutIP.xcodeproj` and run.

## App Store

[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/us/app/scout-ip/id6738300344)

## CI/CD

Every push to `main` triggers a [TestFlight](https://developer.apple.com/testflight/) build via GitHub Actions. Scout package updates are picked up automatically — when tests pass in the Scout repo, a new TestFlight build is triggered with the latest changes.

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| TestFlight | Push to main / Scout update | Build, sign, and upload to TestFlight |
| Build Matrix | Push / PR | Build on iPhone 16 (iOS 18), iPhone 17, iPhone 17 Pro Max (iOS 26) |
| Bundle Size | Push / PR | Track app and binary size |
| Performance | Push to main | Measure launch time and binary size |
| Nightly | Daily at 4:00 UTC | Scheduled TestFlight build |

## License

MIT — see [LICENSE](LICENSE).
