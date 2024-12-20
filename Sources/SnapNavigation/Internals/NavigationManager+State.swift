//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

extension SnapNavigation.NavigationManager {
	
	internal struct State: Hashable, Sendable {
		
        internal typealias Destination = NavigationProvider.Destination
        internal typealias Scene = NavigationProvider.Scene
        internal typealias Route = NavigationProvider.Route
		
		internal var selected: Destination
		private var sceneForSelection: [Destination : Scene] = [:]
		
		private var modals: [Scene] = []
		
		internal init(selected: Destination) {
			self.selected = selected
		}
		
		internal init(route: Route) {
			
            self.init(selected: route.selection)
			
            setup(route.scenes)
		}
        
        mutating internal func setup(_ scenes: [Scene]) {
            for scene in scenes {
                switch scene.context {
                    
                    case .selection(destination: let destination):
                        sceneForSelection[destination] = scene
                    
                    case .modal(level: _):
                        modals.append(scene)
                    
                }
            }
        }
        
        
        // MARK: - Get
        
        internal func getRoot(for context: Scene.Context) -> Destination? {
            switch context {
                case .selection(let destination):
                    return destination
                    
                case .modal(let level):
                    guard let modal = getModal(at: level) else { return nil }
                    return modal.root
            }
        }
        
        private func getModal(at level: SnapNavigation.ModalLevel) -> Scene? {
            guard modalCount > level else { return nil }
            
            return modals[level]
        }
        
        
        // MARK: - Update
        
        mutating internal func push(_ destination: Destination, in context: Scene.Context) {
            var path = getPath(for: context)
            path.append(destination)
            set(path, for: context)
        }
        
        mutating internal func clearPath(for context: Scene.Context) {
            switch context {
                case .selection(let destination):
                    sceneForSelection[destination]?.path = []
                    
                case .modal(let level):
                    if modals.count > level {
                        modals[level].path = []
                    }
            }
        }
        
        
        // MARK: - Path
        
        internal func getPath(for context: Scene.Context) -> Path {
            switch context {
                case .selection(let destination):
                    return sceneForSelection[destination]?.path ?? []
                    
                case .modal(let level):
                    guard let modal = getModal(at: level) else { return [] }
                    return modal.path
            }
        }
        
        mutating internal func set(_ path: Path, for context: Scene.Context) {
            switch context {
                case .selection(let destination):
                    if var scene = sceneForSelection[destination] {
                        scene.path = path
                        sceneForSelection[destination] = scene
                    } else {
                        sceneForSelection[destination] = Scene(context: context, root: destination, path: path)
                    }
                    
                case .modal(let level):
                    if modals.count > level {
                        modals[level].path = path
                    }
            }
        }
        
        
        // MARK: - Modals
        
        internal var modalCount: Int { modals.count }
        
        mutating internal func modalAdd(with destination: Destination) {
            modals.append(Scene(context: .modal(level: modalCount), root: destination, path: []))
        }
        
        mutating internal func modalRemove(at level: SnapNavigation.ModalLevel) { modals.remove(at: level) }
        
        mutating internal func modalDropLast() { modals.removeLast() }
        
        mutating internal func dropAllModals() { modals = [] }
        
    }
    
}
