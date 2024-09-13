//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import Observation

public extension SnapNavigation {
	
	public enum PresentationStyle {
		case select
		case push
		case sheet
	}
	
	@MainActor
	@Observable
	public class State<NavigationProvider: SnapNavigationProvider> {
		
		public typealias Screen = NavigationProvider.Screen
		public typealias Path = [Screen]
		internal typealias Route = [RouteEntry]
		
		internal struct RouteEntry: Equatable, Identifiable, Hashable {
			var id: Int { hashValue }
			var screens: [Screen]
			let style: PresentationStyle
		}
		
		public init(provider: NavigationProvider) {
			self.navigationProvider = provider
			self.selected = provider.initial
		}
		
		
		// MARK: - Navigation
		
		public func navigate(to screen: Screen) {
			var route = route(to: screen)
			
			// Selection
			guard let firstEntry = route.first, firstEntry.style == .select, let firstScreen = firstEntry.screens.first else {
				return
			}

			selected = firstScreen
			route.removeFirst()
			
			// Pushes
			if let entry = route.first, entry.style == .push {
				let path: Path = entry.screens
				setPath(path, for: selected)
			} else {
				setPath([], for: selected)
			}
			
			// Sheets
			dismissSheets()
			for entry in route.filter({ $0.style == .sheet }) {
				if let first = entry.screens.first {
					var path = entry.screens
					path.removeFirst()
					setPath(path, for: first)
					present(screen: first, style: entry.style)
				}
			}

		}
		
		public func present(screen: Screen, style: PresentationStyle) {
			switch style {
				case .select:
					sheets = []
					setPath([], for: screen)
					selected = screen
				case .push:
					push(screen: screen)
				case .sheet:
					sheets.append(RouteEntry(screens: [screen], style: .sheet))
			}
		}
		
		public func push(screen: Screen) {
			var path = getCurrentPath()
			path.append(screen)
			setCurrent(path: path)
		}

		
		// MARK: Dismiss
		
		public func dismissCurrentSheet() {
			sheets.dropLast()
		}
		
		// TODO: Reset sheets should also reset all path bindings?
		public func dismissSheets() {
			sheets = []
		}
		
		public func popCurrentToRoot() {
			setCurrent(path: [])
		}
		
		
		// MARK: Route
		
		internal func route(to screen: Screen) -> Route {
			let route = routeEntries(to: screen)
			
			return condense(route: route)
		}
		
		private func routeEntries(to screen: Screen) -> Route {
			guard let parent = navigationProvider.parent(of: screen) else {
				return [RouteEntry(screens: [screen], style: .select)]
			}
			var routeToParent = routeEntries(to: parent) ?? []
			routeToParent.append(RouteEntry(screens: [screen], style: screen.definition.presentationStyle))
			return routeToParent
		}
		
		// TODO: Unit Tests
		private func condense(route: Route) -> Route {
			var result: Route = []
			var currentEntry: RouteEntry = RouteEntry(screens: [], style: .select)
			for entry in route {
				if entry.style == .push && currentEntry.style != .select {
					currentEntry.screens = currentEntry.screens + entry.screens
				} else {
					if currentEntry.screens.count > 0 {
						result.append(currentEntry)
					}
					currentEntry = entry
				}
			}
			if currentEntry.screens.count > 0 {
				result.append(currentEntry)
			}
			
			return result
		}
		
		
		// MARK: - NavigationProvider
		
		private let navigationProvider: NavigationProvider
		
		public var screens: [Screen] {
			navigationProvider.screens
		}
		
		public func parent(for screen: Screen) -> Screen? {
			navigationProvider.parent(of: screen)
		}
		
		public func subscreens(for screen: Screen) -> [Screen] {
			navigationProvider.subscreens(for: screen)
		}
		
		
		// MARK: - State
		
		public var selected: Screen
		
		
		// MARK: Sheets
		
		internal var sheets: [RouteEntry] = []
		
		internal func sheetBinding(for entry: RouteEntry) -> Binding<RouteEntry?> {
			Binding(get: {
				self.sheets.first(where: { $0.id == entry.id })
			}, set: { screen in
				if let screen {
					if let index = self.sheets.lastIndex(of: screen) {
						self.sheets.remove(at: index)
					}
				} else {
					if let index = self.sheets.firstIndex(where: { $0.id == entry.id }) {
						self.sheets.remove(at: index)
					}
				}
			})
		}
		
		
		// MARK: Paths
		
		private var pathForScreen: [Screen : Path] = [:]
		
		private func getPath(for screen: Screen) -> Path {
			pathForScreen[screen] ?? []
		}
		
		private func setPath(_ path: Path, for screen: Screen) {
#if os(macOS)
			// macOS uses SplitView, where a selection in the sidebar clears the path.
			// Wrapping this in Task applies the new path after the purge.
			Task {
				pathForScreen[screen] = path
			}
#else
			pathForScreen[screen] = path
#endif
		}
		
		private var currentRoot: Screen {
			if let latestSheet = sheets.last, let firstScreen = latestSheet.screens.first {
				return firstScreen
			} else {
				return selected
			}
		}
		
		private func getCurrentPath() -> Path {
			getPath(for: currentRoot)
		}
		
		private func setCurrent(path: Path) {
			setPath(path, for: currentRoot)
		}
		
		@ObservationIgnored
		internal var pathBindingsForScreen: [Screen: Binding<Path>] = [:]
		
		internal func pathBinding(for screen: Screen) -> Binding<Path> {
			if let binding = pathBindingsForScreen[screen] {
				return binding
			}
			
			let binding = Binding<Path> { [weak self] in
				self?.getPath(for: screen) ?? []
			} set: { [weak self] path in
				self?.setPath(path, for: screen)
			}
			
			pathBindingsForScreen[screen] = binding
			return binding
		}
		
	}
	
}
