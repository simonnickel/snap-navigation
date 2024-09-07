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
		
		public var selected: Screen
		
		public func navigate(to screen: Screen) {
			guard var route = route(to: screen) else {
				return
			}
			if let first = route.first {
				route.removeFirst()
				selected = first
#if os(macOS)
				// macOS uses SplitView, where a selection in the sidebar clears the path.
				// Wrapping this in Task applies the new path after the purge.
				Task {
					self.setPath(route, for: first)
				}
#else
				setPath(route, for: first)
#endif
			}
		}
		
		
		// MARK: Presentation
		
		struct PresentationEntry: Equatable, Identifiable {
			let id: UUID
			let screen: NavigationProvider.Screen
		}
		
		var presentations: [PresentationEntry] = []
		
		public func present(screen: Screen) {
			presentations.append(PresentationEntry(id: UUID(), screen: screen))
		}
		
		func presentationBinding(for presentationId: PresentationEntry.ID?) -> Binding<PresentationEntry?> {
			Binding(get: {
				self.presentations.first(where: { $0.id == presentationId })
			}, set: { screen in
				if let screen {
					if let index = self.presentations.lastIndex(of: screen) {
						self.presentations.remove(at: index)
					}
				} else {
					if let index = self.presentations.firstIndex(where: { $0.id == presentationId }) {
						self.presentations.remove(at: index)
					}
				}
			})
		}
		
		
		// MARK: Screens
		
		public var screens: [Screen] {
			navigationProvider.screens
		}
		
		public func route(to screen: Screen) -> Path? {
			navigationProvider.route(to: screen)
		}
		
		public func subscreens(for screen: Screen) -> [Screen] {
			navigationProvider.subscreens(for: screen)
		}
		
		public func parent(of screen: Screen) -> Screen? {
			guard !navigationProvider.screens.contains(screen) else { return nil }
			
			return navigationProvider.screens.first { subscreens(for: $0).contains(screen) }
		}
		
		
		// MARK: Path
		
		private var pathForScreen: [Screen : Path] = [:]
		
		public func getPath(for screen: Screen) -> Path {
			pathForScreen[screen] ?? []
		}
		
		public func setPath(_ path: Path, for screen: Screen) {
			pathForScreen[screen] = path
		}
		
		@ObservationIgnored
		internal var pathBindingsForScreen: [Screen: Binding<Path>] = [:]
		
		public func pathBinding(for screen: Screen) -> Binding<Path> {
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
