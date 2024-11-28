//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

extension SnapNavigation {
	
    internal struct Scene<Destination: SnapNavigationDestination>: Equatable, Identifiable, Hashable, Sendable {
		
		internal typealias Path = [Destination]
		
        var id: String { context.id }
        var context: Context
		var root: Destination
		var path: Path
        
        internal enum Context: Hashable, Identifiable {
            case selection(destination: Destination)
            case modal(level: SnapNavigation.ModalLevel)
            
            var id: String {
                switch self {
                case .selection(let destination): "selection-\(destination.id)"
                case .modal(let level): "modal-\(level)"
                }
            }
        }
        
    }
    
}
