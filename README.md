# Scout IP

[![Build Matrix](https://github.com/kasianov-mikhail/scout-ip/actions/workflows/build-matrix.yml/badge.svg)](https://github.com/kasianov-mikhail/scout-ip/actions/workflows/build-matrix.yml) [![TestFlight](https://github.com/kasianov-mikhail/scout-ip/actions/workflows/testflight.yml/badge.svg)](https://github.com/kasianov-mikhail/scout-ip/actions/workflows/testflight.yml) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) ![Platform](https://img.shields.io/badge/platform-iOS%2017%2B-blue) ![Swift](https://img.shields.io/badge/Swift-6.0-orange)


A companion app for the [Scout](https://github.com/kasianov-mikhail/scout) package. Scout IP uses your device's public IP address to generate real-world logs, metrics, and activity data — providing a live environment to test and verify Scout's features through its built-in dashboard.

## Table of Contents
- [Features](#features)
- [Setup](#setup)
- [App Store](#app-store)

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
    cd scout-ip
    ```
2. Get an API token from [ipinfo.io/account/token](https://ipinfo.io/account/token).
3. Expose it to the app as the `IPINFO_KEY` environment variable — Debug builds read it at runtime. In Xcode, open **Product → Scheme → Edit Scheme → Run → Arguments → Environment Variables** and add `IPINFO_KEY` with your token. Keep the value out of version control. Without a token the app still runs and simply skips IP lookups.
4. Open `ScoutIP.xcodeproj` and run. The [Scout](https://github.com/kasianov-mikhail/scout) package is fetched automatically as a remote dependency.

## Workspace (optional)

`ScoutIP.xcworkspace` also surfaces the source of the [`scout`](https://github.com/kasianov-mikhail/scout), [`scout-db`](https://github.com/kasianov-mikhail/scout-db), and [`scout-server`](https://github.com/kasianov-mikhail/scout-server) packages so you can edit them alongside the app. They live as sibling folders next to `scout-ip`; run the bootstrap script to clone any that are missing:

```sh
./bootstrap.sh
```

Then open `ScoutIP.xcworkspace` instead of the project. With `scout` checked out locally, Xcode builds against your local copy instead of the remote dependency.

## App Store

[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/us/app/scout-ip/id6738300344)
