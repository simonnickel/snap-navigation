//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import Observation
import OSLog

extension SnapNavigation {
	
	@Observable
	final public class Navigator<NavigationProvider: SnapNavigationProvider> {
		
		public typealias Destination = NavigationProvider.Destination
		public typealias Path = [Destination]
		
		internal typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
		public typealias NavigationScene = SnapNavigation.NavigationScene<NavigationProvider.Destination>

		private weak var navigationManager: NavigationManager?
		
		internal let scene: NavigationScene
		
		private var state: State
		
		internal init(navigationManager: NavigationManager, scene: NavigationScene) {
			self.navigationManager = navigationManager
			self.scene = scene
			
			switch scene {
				case .main:
					self.state = State(selected: navigationManager.navigationProvider.initial(for: .main))
					
				case .settings:
					self.state = State(selected: navigationManager.navigationProvider.initial(for: .settings))
					
				case .window(id: _, style: _, content: let content):
					switch content {
							
						case .destination(let destination):
							self.state = State(selected: destination)
							
						case .route(to: let destination):
							let route = navigationManager.navigationProvider.route(to: destination)
							self.state = State(route: route)
							
					}
					
			}
		}
		
		private var navigationProvider: NavigationProvider {
			guard let navigationManager else { fatalError("NavigationManager not available!") }
			return navigationManager.navigationProvider
		}
		
		
		// MARK: - Navigation
		
		@MainActor
		public func navigate(to destination: Destination) {
			var route = navigationProvider.route(to: destination)
			state.update(route)
		}
		
		
		// MARK: Open Window
		
		public var supportsMultipleWindows: Bool { navigationManager?.supportsMultipleWindows ?? false}
		
		@MainActor
		public func window(_ content: NavigationScene.Content, style: NavigationStyle) {
			guard ProcessInfo.isPreview == false else {
				Logger.navigation.warning("Multiple windows are not supported in Previews!")
				return
			}
			
			guard let openWindow = navigationManager?.openWindow else {
				fatalError("Navigation Managers open window action is not set!")
			}
			
			guard supportsMultipleWindows else {
				Logger.navigation.warning("Tried to open a window in an environment where `supportsMultipleWindows == false`!")
				return
			}
			
			let scene = NavigationScene.window(id: UUID(), style: style, content: content)
			openWindow(value: scene)
		}
		
		
		// MARK: Present
		
		@MainActor
		public func present(destination: Destination, style styleOverride: PresentationStyle? = nil) {
			let style = styleOverride ?? destination.definition.presentationStyle
			switch style {
				case .select:
					state.modals = []
					setPath([], for: .selection(destination: destination))
					state.selected = destination
					
				case .push:
					var path = getPath(for: pathContextCurrent)
					path.append(destination)
					setPath(path, for: pathContextCurrent)
					
				case .modal:
					state.modals.append(RouteEntry(root: destination, path: [], style: .modal))
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
			case selection(destination: Destination)
			case modal(level: ModalLevel)
		}
		
		private func getPath(for context: PathContext) -> Path {
			switch context {
				case .selection(let destination):
					return state.pathForSelection[destination] ?? []
					
				case .modal(let level):
					guard state.modals.count > level else { return [] }
					return state.modals[level].path
			}
		}
		
		private func setPath(_ path: Path, for context: PathContext) {
			state.update(path, for: context)
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
				case .selection(let destination):
					binding = Binding<Path> { [weak self] in
						self?.getPath(for: .selection(destination: destination)) ?? []
					} set: { [weak self] path in
						self?.setPath(path, for: .selection(destination: destination))
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
	
	internal var selected: Destination {
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
			return .selection(destination: state.selected)
		}
	}
	
	internal func root(for context: PathContext) -> Destination? {
		switch context {
			case .selection(let destination):
				return destination
				
			case .modal(let level):
				guard state.modals.count > level else { return nil }
				
				let entry = state.modals[level]
				return entry.root
		}
	}
	
	
	// MARK: NavigationProvider
	
	public var destinations: [Destination] {
		navigationProvider.selectableDestinations
	}
	
	public func parent(for destination: Destination) -> Destination? {
		navigationProvider.parent(of: destination)
	}
	
}
