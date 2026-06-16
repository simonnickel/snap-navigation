@../snap/agents/AGENTS-shared.md

# SnapNavigation

Defines the navigation hierarchy of a SwiftUI app as data (Destinations + a Provider) and drives presentation (NavigationStack, tabs, modals, windows) from that data via an internal `NavigationManager`.

## Key types

- **`SnapNavigationDestination`** — public protocol; each case of the app's `Destination` enum is a screen.
- **`SnapNavigationProvider`** — public protocol; defines the initial screen, root destinations per window, the parent-child hierarchy used for deeplink routing, and `translate(_:)` for type-erasure.
- **`NavigationManager`** — internal `@MainActor @Observable` class; holds all navigation `State` and produces SwiftUI bindings from it. One instance per `Window`, managed by `WindowManager`.
- **`Scene`** — internal struct; one `NavigationStack`, identified by a `Context` (`.selection(destination:)` or `.modal(elevation:)`). `Scene.Context` is the key for all path and root lookups.

## Key patterns

**`translate(_:)` before acting on any destination** — `NavigatorAction` uses `any SnapNavigationDestination` for type-erasure. Every handler must call `provider.translate(_:)` to get the concrete `Destination` before acting. New action cases must do the same.

**Modal elevation model** — Modals are a 0-based stack. `ModalPresentationModifier` starts at `elevationCurrent` (the highest index) and recurses downward, calling `elevationInverted(_:)` to convert the iteration counter to the actual modal index. State mutations use the direct index, not the inverted one.

**`rootDestinationOptions` vs `rootDestinations(for:)`** — `rootDestinationOptions` (static) is the full set of possible tab/root destinations; `rootDestinations(for:)` returns the subset enabled for a given window.

## Visibility

Everything under `Internals/` is `internal`. Do not expose internal types in the public API.
