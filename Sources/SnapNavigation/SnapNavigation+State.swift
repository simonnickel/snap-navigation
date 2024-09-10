//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import Observation

public extension SnapNavigation {
	
	@MainActor
	@Observable
	public class State<NavigationProvider: SnapNavigationProvider> {
		
		public typealias Screen = NavigationProvider.Screen
		public typealias Path = [Screen]
		
		private let navigationProvider: NavigationProvider
		
		public init(provider: NavigationProvider) {
			self.navigationProvider = provider
			self.selected = provider.initial
		}
		
		
		// MARK: Navigation
		
		struct PresentationEntry: Equatable, Identifiable {
			let id: UUID
			let screen: NavigationProvider.Screen
		}
		
		public func navigate(to screen: Screen) {
			var route = route(to: screen)
			
			if let first = route.first {
				route.removeFirst()
				selected = first
				setPath(path, for: selected)
			}
		}
		
		public func present(screen: Screen) {
			sheets.append(PresentationEntry(id: UUID(), screen: screen))
		}
		
		public func push(screen: Screen) {
			var path = getCurrentPath()
			path.append(screen)
			setCurrent(path: path)
		}
		
		internal func route(to screen: Screen) -> Path {
			guard let parent = navigationProvider.parent(of: screen) else {
				return [screen]
			}
			var pathToParent = route(to: parent) ?? []
			pathToParent.append(screen)
			return pathToParent
		}
		
		
		// MARK: Screens
		
		public var screens: [Screen] {
			navigationProvider.screens
		}
		
		public func subscreens(for screen: Screen) -> [Screen] {
			navigationProvider.subscreens(for: screen)
		}
		
		
		// MARK: Selection
		
		public var selected: Screen
		
		
		// MARK: Sheets
		
		internal var sheets: [PresentationEntry] = []
		
		internal func sheetBinding(for presentationId: PresentationEntry.ID?) -> Binding<PresentationEntry?> {
			Binding(get: {
				self.sheets.first(where: { $0.id == presentationId })
			}, set: { screen in
				if let screen {
					if let index = self.sheets.lastIndex(of: screen) {
						self.sheets.remove(at: index)
					}
				} else {
					if let index = self.sheets.firstIndex(where: { $0.id == presentationId }) {
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
		
		private func getCurrentPath() -> Path {
			getPath(for: selected)
		}
		
		private func setCurrent(path: Path) {
			setPath(path, for: selected)
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
