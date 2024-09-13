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
			var root: Screen
			var path: Path
			let style: PresentationStyle
		}
		
		public init(provider: NavigationProvider) {
			self.navigationProvider = provider
			self.selected = provider.initial
		}
		
		
		// MARK: - Navigation
		
		public func navigate(to screen: Screen) {
			var route = route(to: screen)
			
			// Select
			guard let firstEntry = route.first, firstEntry.style == .select else {
				return
			}

			selected = firstEntry.root
			route.removeFirst()
			
			// Push
			if let entry = route.first, entry.style == .push {
				setPath(entry.path, for: .selection(screen: selected))
			} else {
				setPath([], for: .selection(screen: selected))
			}
			
			// Sheets
			dismissSheets()
			for entry in route.filter({ $0.style == .sheet }) {
				sheets.append(entry)
			}

		}
		
		public func present(screen: Screen, style: PresentationStyle) {
			switch style {
				case .select:
					sheets = []
					setPath([], for: .selection(screen: screen))
					selected = screen
				case .push:
					var path = getCurrentPath()
					path.append(screen)
					setCurrent(path: path)
				case .sheet:
					sheets.append(RouteEntry(root: screen, path: [], style: .sheet))
			}
		}

		
		// MARK: Dismiss
		
		public func dismissCurrentSheet() {
			sheets.removeLast()
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
				return [RouteEntry(root: screen, path: [], style: .select)]
			}
			var routeToParent = routeEntries(to: parent) ?? []
			routeToParent.append(RouteEntry(root: screen, path: [], style: screen.definition.presentationStyle))
			return routeToParent
		}
		
		private func condense(route: Route) -> Route {
			var route = route
			var result: Route = []
			guard let first = route.first else { return result }
			
			var currentEntry: RouteEntry = first
			route.removeFirst()
			
			for entry in route {
				if entry.style == .push && currentEntry.style != .select {
					currentEntry.path = currentEntry.path + [entry.root] + entry.path
				} else {
					result.append(currentEntry)
					currentEntry = entry
				}
			}
			result.append(currentEntry)
			
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
		
		internal func sheetLevelInverted(_ level: Int) -> Int {
			return sheets.count - 1 - level
		}
		
		@ObservationIgnored
		private var sheetBindingsForLevel: [Int: Binding<Bool>] = [:]
		
		internal func sheetBinding(for level: Int) -> Binding<Bool> {
			if let binding = sheetBindingsForLevel[level] {
				return binding
			}
			
			let binding = Binding(get: { [weak self] in
				self?.sheets.count ?? 0 > level
			}, set: { [weak self] isPresented in
				if !isPresented && self?.sheets.count ?? 0 > level {
					self?.sheets.remove(at: level)
				}
			})
			
			sheetBindingsForLevel[level] = binding
			return binding
		}
		
		
		// MARK: Paths
		
		internal enum PathContext {
			case selection(screen: Screen)
			case sheet(level: Int)
		}
		
		internal func rootScreen(for context: PathContext) -> Screen? {
			switch context {
				case .selection(let screen):
					return screen
					
				case .sheet(let level):
					guard sheets.count > level else { return nil }
					
					let entry = sheets[level]
					return entry.root
			}
		}
		
		internal func pathBinding(for context: PathContext) -> Binding<Path> {
			switch context {
				case .selection(let screen): pathBinding(for: screen)
				case .sheet(let level): pathBinding(for: level)
			}
		}
		
		@ObservationIgnored
		private var pathBindingsForLevel: [Int: Binding<Path>] = [:]

		internal func pathBinding(for level: Int) -> Binding<Path> {
			if let binding = pathBindingsForLevel[level] {
				return binding
			}
			let binding = Binding<Path> { [weak self] in
				self?.getPath(for: .sheet(level: level)) ?? []
			} set: { [weak self] path in
				self?.setPath(path, for: .sheet(level: level))
			}
			
			pathBindingsForLevel[level] = binding
			return binding
		}
		
		private var pathForScreen: [Screen : Path] = [:]
		
		private var currentPathContext: PathContext {
			if sheets.count > 0 {
				return .sheet(level: sheets.count - 1)
			} else {
				return .selection(screen: selected)
			}
		}
		
		private func getPath(for context: PathContext) -> Path {
			switch context {
				case .selection(let screen):
					return pathForScreen[screen] ?? []
					
				case .sheet(let level):
					guard sheets.count > level else { return [] }
					return sheets[level].path
			}
		}
		
		private func setPath(_ path: Path, for context: PathContext) {
			switch context {
				case .selection(let screen):
#if os(macOS)
					// macOS uses SplitView, where a selection in the sidebar clears the path.
					// Wrapping this in Task applies the new path after the purge.
					Task {
						pathForScreen[screen] = path
					}
#else
					pathForScreen[screen] = path
#endif
					
				case .sheet(let level):
					if sheets.count > level {
						var entry = sheets[level]
						entry.path = path
						sheets[level] = entry
					}
			}
		}
		private func getCurrentPath() -> Path {
			
			getPath(for: currentPathContext)
		}
		
		private func setCurrent(path: Path) {
			setPath(path, for: currentPathContext)
		}
		
		@ObservationIgnored
		private var pathBindingsForScreen: [Screen: Binding<Path>] = [:]
		
		private func pathBinding(for screen: Screen) -> Binding<Path> {
			if let binding = pathBindingsForScreen[screen] {
				return binding
			}
			
			let binding = Binding<Path> { [weak self] in
				self?.getPath(for: .selection(screen: screen)) ?? []
			} set: { [weak self] path in
				self?.setPath(path, for: .selection(screen: screen))
			}
			
			pathBindingsForScreen[screen] = binding
			return binding
		}
		
	}
	
}
