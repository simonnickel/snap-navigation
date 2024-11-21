//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Observation
import OSLog
import SwiftUI

extension SnapNavigation {
	
	@MainActor
	@Observable // Is Observable to be Bindable and used as EnvironmentObject.
    final public class Navigator<NavigationProvider: SnapNavigationProvider> {
        
        public typealias Window = SnapNavigation.Window<Destination>
        public typealias Destination = NavigationProvider.Destination
        internal typealias Scene = NavigationProvider.Scene
        internal typealias Route = NavigationProvider.Route
        public typealias Path = [Destination]

		internal let provider: NavigationProvider
		internal let window: Window
		
        internal var state: State {
            didSet {
                stateHash = state.hashValue
            }
        }
        
        public var stateHash: Int = 0 {
            didSet {
                translator.stateHash = stateHash
            }
        }
        
        @ObservationIgnored
        internal lazy var translator: NavigatorTranslator = {
            createTranslator()
        }()
		
		internal init(provider: NavigationProvider, window: Window, supportsMultipleWindows: Bool, openWindow: OpenWindowAction) {
			self.provider = provider
			self.window = window
			self.supportsMultipleWindows = supportsMultipleWindows
			self.openWindow = openWindow
			
			switch window {
				case .main:
					self.state = State(selected: provider.initial(for: .main))
					
				case .settings:
					self.state = State(selected: provider.initial(for: .settings))
					
				case .window(id: _, style: _, initial: let content):
					switch content {
							
						case .destination(let destination):
							self.state = State(selected: destination)
							
						case .route(to: let destination):
							let route = provider.route(to: destination)
							self.state = State(route: route)
							
					}
					
			}
		}
		
		
		// MARK: - Navigation
		
		public func navigate(to destination: Destination) {
			let route = provider.route(to: destination)
            state.setup(route.scenes)
            state.selected = route.selection
		}
		
		
		// MARK: Open Window
		
		public private(set) var supportsMultipleWindows: Bool
		private var openWindow: OpenWindowAction
        
        internal func update(supportsMultipleWindows: Bool, openWindow: OpenWindowAction) {
            self.supportsMultipleWindows = supportsMultipleWindows
            self.openWindow = openWindow
        }
		
		public func window(_ initial: Window.InitialContent, style: NavigationStyle) {
			guard ProcessInfo.isPreview == false else {
				Logger.navigation.warning("Multiple windows are not supported in Previews!")
				return
			}
			
			guard supportsMultipleWindows else {
				Logger.navigation.warning("Tried to open a window in an environment where `supportsMultipleWindows == false`!")
				return
			}
			
			let window = Window.window(id: UUID(), style: style, initial: initial)
			openWindow(value: window)
		}
		
		
		// MARK: Present
		
		public func present(destination: Destination, style styleOverride: PresentationStyle? = nil) {
			let style = styleOverride ?? destination.definition.presentationStyle
			switch style {
				case .select:
                    state.dropAllModals()
                    state.clearPath(for: .selection(destination: destination))
					state.selected = destination
					
				case .push:
                    state.push(destination, in: currentSceneContext)
					
				case .modal:
                    state.modalAdd(with: destination)
			}
		}

		
		// MARK: Dismiss
		
		public func dismissCurrentModal() {
			if state.modalCount > 0 {
                state.modalDropLast()
			}
		}
		
		public func dismissModals() {
            state.dropAllModals()
		}
		
		public func popCurrentToRoot() {
            state.clearPath(for: currentSceneContext)
		}
		
		
		// MARK: - Path Bindings
		
		@ObservationIgnored
        private var pathBindingsForContext: [Scene.Context: Binding<Path>] = [:]
		
        internal func pathBinding(for context: Scene.Context) -> Binding<Path> {
			if let binding = pathBindingsForContext[context] {
				return binding
			}
			let binding: Binding<Path>
			switch context {
				case .selection(let destination):
					binding = Binding<Path> { [weak self] in
                        self?.state.getPath(for: .selection(destination: destination)) ?? []
					} set: { [weak self] path in
                        self?.state.set(path, for: .selection(destination: destination))
					}
					
				case .modal(let level):
					binding = Binding<Path> { [weak self] in
                        self?.state.getPath(for: .modal(level: level)) ?? []
					} set: { [weak self] path in
                        self?.state.set(path, for: .modal(level: level))
					}
			}
			
			pathBindingsForContext[context] = binding
			return binding
		}
		
		
		// MARK: - Modal Bindings
		
		@ObservationIgnored
		private var modalBindingsForLevel: [ModalLevel: Binding<Bool>] = [:]
		
		internal func modalBinding(for level: ModalLevel) -> Binding<Bool> {
			if let binding = modalBindingsForLevel[level] {
				return binding
			}
			
			let binding = Binding(get: { [weak self] in
				self?.state.modalCount ?? 0 > level
			}, set: { [weak self] isPresented in
				if !isPresented && self?.state.modalCount ?? 0 > level {
                    self?.state.modalRemove(at: level)
				}
			})
			
			modalBindingsForLevel[level] = binding
			return binding
		}
        
	}
	
}


// MARK: - Convenience

extension SnapNavigation.Navigator {
	
    private var currentSceneContext: Scene.Context {
        if modalLevelCurrent >= 0 {
            return .modal(level: modalLevelCurrent)
        } else {
            return .selection(destination: state.selected)
        }
    }
    
	
	// MARK: State
	
	internal var selected: Destination {
		get { state.selected }
		set { state.selected = newValue }
	}
    
    internal func root(for context: Scene.Context) -> Destination? {
        state.getRoot(for: context)
    }
    
	
	// MARK: Modals
	
    internal var modalLevelCurrent: SnapNavigation.ModalLevel { state.modalCount - 1 }
	
	internal func modalLevelInverted(_ level: SnapNavigation.ModalLevel) -> SnapNavigation.ModalLevel {
		return state.modalCount - 1 - level
	}
	
	
	// MARK: NavigationProvider
	
	public var selectableDestinations: [Destination] {
		provider.selectableDestinations(for: window)
	}
	
	public func parent(for destination: Destination) -> Destination? {
		provider.parent(of: destination)
	}
	
}
