//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

extension SnapNavigation {
    
    internal struct Route<Destination: SnapNavigationDestination>: Hashable {
        
        internal typealias Scene = SnapNavigation.Scene<Destination>
        
        internal struct Entry: Hashable {
            var destination: Destination
            let style: PresentationStyle
        }
        
        internal let selection: Destination
        internal let scenes: [Scene]
        
        internal init(entries: [Entry]) {
            var entries = entries
            var scenes: [Scene] = []
            guard let first = entries.first else { fatalError("A Route can not be empty!") }
            guard first.style == .select else { fatalError("A Route needs to start with a .select entry!") }
            
            entries.removeFirst()
            
            var currentScene = Scene(context: .selection(destination: first.destination), root: first.destination, path: [])
            
            for entry in entries {
                switch entry.style {
                    case .select:
                        fatalError("A Route can only have a single selection as first entry!")
                    
                    case .push:
                        currentScene.path = currentScene.path + [entry.destination]
                    
                    case .modal:
                        scenes.append(currentScene)
                        currentScene = Scene(context: .modal(elevation: scenes.count - 1), root: entry.destination, path: [])

                }
            }
            scenes.append(currentScene)
            
            self.selection = first.destination
            self.scenes = scenes
        }
    }

}
