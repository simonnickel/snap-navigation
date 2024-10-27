//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

public protocol SnapNavigationProvider {
	
	associatedtype Destination: SnapNavigationDestination
	
	var initialSelection: Destination { get }
	
	var selectableDestinations: [Destination] { get }
	
	func parent(of destination: Destination) -> Destination?
	
}
