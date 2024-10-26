//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import Observation

extension SnapNavigation {
	
	@Observable
	final public class Navigator<NavigationProvider: SnapNavigationProvider> {
		
		public typealias Screen = NavigationProvider.Screen
		public typealias Path = [Screen]
		
		private let navigationProvider: NavigationProvider

		private var state: State

		public init(provider: NavigationProvider) {
			self.navigationProvider = provider
			self.state = State(selected: provider.initialSelection)
		}
		
		
		// MARK: - State
		
		private struct State: Sendable {
			internal var selected: Screen
			internal var pathForSelection: [Screen : Path] = [:]
			
			internal var modals: [RouteEntry<Screen>] = []
		}
		
		
		// MARK: - Navigation
		
		@MainActor
		public func navigate(to screen: Screen) {
			var route = navigationProvider.route(to: screen)
			
			// Select
			guard let firstEntry = route.first, firstEntry.style == .select else {
				return
			}

			self.state.selected = firstEntry.root
			route.removeFirst()
			
			// Push
			if let entry = route.first, entry.style == .push {
				setPath([entry.root] + entry.path, for: .selection(screen: state.selected))
			} else {
				setPath([], for: .selection(screen: state.selected))
			}
			
			// Modals
			dismissModals()
			for entry in route.filter({ $0.style == .modal }) {
				state.modals.append(entry)
			}
		}
		
		
		// MARK: Present
		
		@MainActor
		public func present(screen: Screen, style styleOverride: PresentationStyle? = nil) {
			let style = styleOverride ?? screen.definition.presentationStyle
			switch style {
				case .select:
					state.modals = []
					setPath([], for: .selection(screen: screen))
					state.selected = screen
					
				case .push:
					var path = getPath(for: pathContextCurrent)
					path.append(screen)
					setPath(path, for: pathContextCurrent)
					
				case .modal:
					state.modals.append(RouteEntry(root: screen, path: [], style: .modal))
			}
		}

		
		// MARK: Dismiss
		
		@MainActor
		public func dismissCurrentModal() {
			if state.modals.count > 0 {
				state.modals.removeLast()
			}
		}
		
		@MainActor
		public func dismissModals() {
			state.modals = []
		}
		
		@MainActor
		public func popCurrentToRoot() {
			setPath([], for: pathContextCurrent)
		}
		
		
		// MARK: - Paths
		
		internal enum PathContext: Hashable {
			case selection(screen: Screen)
			case modal(level: ModalLevel)
		}
		
		private func getPath(for context: PathContext) -> Path {
			switch context {
				case .selection(let screen):
					return state.pathForSelection[screen] ?? []
					
				case .modal(let level):
					guard state.modals.count > level else { return [] }
					return state.modals[level].path
			}
		}
		
		private func setPath(_ path: Path, for context: PathContext) {
			switch context {
				case .selection(let screen):
#if os(macOS)
					// macOS uses SplitView, where a selection in the sidebar clears the path.
					// Wrapping this in Task applies the new path after the purge.
					Task {
						state.pathForSelection[screen] = path
					}
#else
					state.pathForSelection[screen] = path
#endif
					
				case .modal(let level):
					if state.modals.count > level {
						var entry = state.modals[level]
						entry.path = path
						state.modals[level] = entry
					}
			}
		}
		
		// MARK: - Path Bindings
		
		@ObservationIgnored
		private var pathBindingsForContext: [PathContext: Binding<Path>] = [:]
		
		@MainActor
		internal func pathBinding(for context: PathContext) -> Binding<Path> {
			if let binding = pathBindingsForContext[context] {
				return binding
			}
			let binding: Binding<Path>
			switch context {
				case .selection(let screen):
					binding = Binding<Path> { [weak self] in
						self?.getPath(for: .selection(screen: screen)) ?? []
					} set: { [weak self] path in
						self?.setPath(path, for: .selection(screen: screen))
					}
					
				case .modal(let level):
					binding = Binding<Path> { [weak self] in
						self?.getPath(for: .modal(level: level)) ?? []
					} set: { [weak self] path in
						self?.setPath(path, for: .modal(level: level))
					}
			}
			
			pathBindingsForContext[context] = binding
			return binding
		}
		
		
		// MARK: - Modal Bindings
		
		@ObservationIgnored
		private var modalBindingsForLevel: [ModalLevel: Binding<Bool>] = [:]
		
		@MainActor
		internal func modalBinding(for level: ModalLevel) -> Binding<Bool> {
			if let binding = modalBindingsForLevel[level] {
				return binding
			}
			
			let binding = Binding(get: { [weak self] in
				self?.state.modals.count ?? 0 > level
			}, set: { [weak self] isPresented in
				if !isPresented && self?.state.modals.count ?? 0 > level {
					self?.state.modals.remove(at: level)
				}
			})
			
			modalBindingsForLevel[level] = binding
			return binding
		}
	}
	
}


// MARK: - Convenience

extension SnapNavigation.Navigator {
	
	
	// MARK: State
	
	internal var selected: Screen {
		get { state.selected }
		set { state.selected = newValue }
	}
	
	
	// MARK: Modals
	
	internal var modalLevelCurrent: SnapNavigation.ModalLevel { state.modals.count - 1 }
	
	internal func modalLevelInverted(_ level: SnapNavigation.ModalLevel) -> SnapNavigation.ModalLevel {
		return state.modals.count - 1 - level
	}
	
	
	// MARK: Navigator
	
	private var pathContextCurrent: PathContext {
		if modalLevelCurrent >= 0 {
			return .modal(level: modalLevelCurrent)
		} else {
			return .selection(screen: state.selected)
		}
	}
	
	internal func root(for context: PathContext) -> Screen? {
		switch context {
			case .selection(let screen):
				return screen
				
			case .modal(let level):
				guard state.modals.count > level else { return nil }
				
				let entry = state.modals[level]
				return entry.root
		}
	}
	
	
	// MARK: NavigationProvider
	
	public var screens: [Screen] {
		navigationProvider.selectableScreens
	}
	
	public func parent(for screen: Screen) -> Screen? {
		navigationProvider.parent(of: screen)
	}
	
}
