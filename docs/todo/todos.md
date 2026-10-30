# TODO

Outstanding work on the package.

## TODO-1: Modals close on background tap

On iPad, tapping in the background while 2 modals are open closes all modals. Fix it to close only the top one.

## TODO-2: Keyboard navigation

Support keyboard navigation.

## TODO-3: Accessibility

Improve accessibility support.

## TODO-4: Sidebar reordering

Support reordering items in the sidebar.

## TODO-5: Full screen cover

Define `fullScreenCover` as an additional presentation style. It can only be presented once, as the last item, with a path to show and no modals on top. It might even get its own `SnapNavigationView` and state.

## TODO-6: Tab state on macOS

On macOS, `TabView` with `.sidebarAdaptable` does not maintain the state of the selected tab or sidebar item. Find a way to maintain the navigation state.
