//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

/// Implement a `SnapNavigationProvider` to provide the initial screen and `Destination`s to select. Also provides the navigation hierarchy for a deeplink by linking each destination to a parent.
public protocol SnapNavigationProvider {
	
	associatedtype Destination: SnapNavigationDestination
	
	func initial(for window: SnapNavigation.Window<Destination>.Initializable) -> Destination
    
    /// Destinations _available_ for selection as navigation flow root, e.g. as tabs in a tabbed navigation.
    static var rootDestinationOptions: [Destination] { get }
	
    /// Destinations _enabled_ as navigation flow root for a window (e.g. as tabs in a tabbed navigation).
	func rootDestinations(for window: SnapNavigation.Window<Destination>) -> [Destination]
	
	func parent(of destination: Destination) -> Destination?
	
	func translate(_ destination: any SnapNavigationDestination) -> Destination?
	
}
