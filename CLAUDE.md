# Maintaining these instructions

- When you notice recurring feedback or a new convention that isn't captured yet, proactively propose adding it as a rule — surface it as a suggested edit for the user to approve rather than editing on your own initiative. General Swift style, code organization and structure rules go to the shared user-level rule `~/.claude/rules/swift-style.md` (loaded automatically for Swift files in scout, scout-db, scout-server and scout-ip); only scout-ip-specific conventions go here.

# Trackers

- Trackers carry no per-call state: define them as caseless `enum`s with `static` methods rather than instantiable `struct`s, so call sites read `FooTracker.event()` instead of `FooTracker().event()`. The exception is a tracker that holds a value for the span of a single operation (e.g. `source`), which stays a `struct`.
