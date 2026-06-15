When pushing new commits to an existing PR, update its title and description to reflect the full scope of changes.

When you notice recurring feedback or a new project convention that isn't captured here yet, proactively propose adding it as a rule to this file — surface it as a suggested edit for the user to approve rather than editing on your own initiative.

Trackers carry no per-call state: define them as caseless `enum`s with `static` methods rather than instantiable `struct`s, so call sites read `FooTracker.event()` instead of `FooTracker().event()`. The exception is a tracker that holds a value for the span of a single operation (e.g. `source`), which stays a `struct`.

Document only public API: write doc comments (`///`) for `public`/`open` declarations only, and leave `internal`, `private`, and `fileprivate` declarations undocumented (an inline `//` note for genuinely non-obvious logic is still fine).
