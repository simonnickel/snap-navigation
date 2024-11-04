//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

/// Implement a `SnapNavigationProvider` to provide the initial screen and `Destination`s to select. Also provides the navigation hierarchy for a deeplink by linking each destination to a parent.
public protocol SnapNavigationProvider {
	
	associatedtype Destination: SnapNavigationDestination
	
	var initialSelection: Destination { get }
	
	var selectableDestinations: [Destination] { get }
	
	func parent(of destination: Destination) -> Destination?
	
}
