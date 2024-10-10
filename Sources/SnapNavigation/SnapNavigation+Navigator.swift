//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import Observation

public extension SnapNavigation {
	
	@MainActor
	@Observable
	public class Navigator<NavigationProvider: SnapNavigationProvider> {
		
		public typealias Screen = NavigationProvider.Screen
		public typealias Path = [Screen]
		
		private let navigationProvider: NavigationProvider

		public init(provider: NavigationProvider) {
			self.navigationProvider = provider
			self.selected = provider.initialSelection
		}
		
		
		// MARK: - Navigation
		
		public func navigate(to screen: Screen) {
			var route = navigationProvider.route(to: screen)
			
			// Select
			guard let firstEntry = route.first, firstEntry.style == .select else {
				return
			}

			selected = firstEntry.root
			route.removeFirst()
			
			// Push
			if let entry = route.first, entry.style == .push {
				setPath([entry.root] + entry.path, for: .selection(screen: selected))
			} else {
				setPath([], for: .selection(screen: selected))
			}
			
			// Modals
			dismissModals()
			for entry in route.filter({ $0.style == .modal }) {
				modals.append(entry)
			}
		}
		
		public func present(screen: Screen, style styleOverride: PresentationStyle? = nil) {
			let style = styleOverride ?? screen.definition.presentationStyle
			switch style {
				case .select:
					modals = []
					setPath([], for: .selection(screen: screen))
					selected = screen
					
				case .push:
					var path = getPath(for: pathContextCurrent)
					path.append(screen)
					setPath(path, for: pathContextCurrent)
					
				case .modal:
					modals.append(RouteEntry(root: screen, path: [], style: .modal))
			}
		}

		
		// MARK: Dismiss
		
		public func dismissCurrentModal() {
			if modals.count > 0 {
				modals.removeLast()
			}
		}
		
		public func dismissModals() {
			modals = []
		}
		
		public func popCurrentToRoot() {
			setPath([], for: pathContextCurrent)
		}
		
		
		// MARK: - Selection
		
		public var selected: Screen
		
		private var pathForSelection: [Screen : Path] = [:]
		
		
		// MARK: - Modals
		
		private var modals: [RouteEntry<Screen>] = []
		
		internal var modalLevelCurrent: ModalLevel { modals.count - 1 }
		
		internal func modalLevelInverted(_ level: ModalLevel) -> ModalLevel {
			return modals.count - 1 - level
		}
		
		@ObservationIgnored
		private var modalBindingsForLevel: [ModalLevel: Binding<Bool>] = [:]
		
		internal func modalBinding(for level: ModalLevel) -> Binding<Bool> {
			if let binding = modalBindingsForLevel[level] {
				return binding
			}
			
			let binding = Binding(get: { [weak self] in
				self?.modals.count ?? 0 > level
			}, set: { [weak self] isPresented in
				if !isPresented && self?.modals.count ?? 0 > level {
					self?.modals.remove(at: level)
				}
			})
			
			modalBindingsForLevel[level] = binding
			return binding
		}
		
		
		// MARK: - Paths
		
		internal enum PathContext: Hashable {
			case selection(screen: Screen)
			case modal(level: ModalLevel)
		}
		
		@ObservationIgnored
		private var pathBindingsForContext: [PathContext: Binding<Path>] = [:]
		
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
		
		private func getPath(for context: PathContext) -> Path {
			switch context {
				case .selection(let screen):
					return pathForSelection[screen] ?? []
					
				case .modal(let level):
					guard modals.count > level else { return [] }
					return modals[level].path
			}
		}
		
		private func setPath(_ path: Path, for context: PathContext) {
			switch context {
				case .selection(let screen):
#if os(macOS)
					// macOS uses SplitView, where a selection in the sidebar clears the path.
					// Wrapping this in Task applies the new path after the purge.
					Task {
						pathForSelection[screen] = path
					}
#else
					pathForSelection[screen] = path
#endif
					
				case .modal(let level):
					if modals.count > level {
						var entry = modals[level]
						entry.path = path
						modals[level] = entry
					}
			}
		}
		
	}
	
}


// MARK: - Convenience

extension SnapNavigation.Navigator {
	
	
	// MARK: Navigator
	
	private var pathContextCurrent: PathContext {
		if modalLevelCurrent >= 0 {
			return .modal(level: modalLevelCurrent)
		} else {
			return .selection(screen: selected)
		}
	}
	
	internal func root(for context: PathContext) -> Screen? {
		switch context {
			case .selection(let screen):
				return screen
				
			case .modal(let level):
				guard modals.count > level else { return nil }
				
				let entry = modals[level]
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
