//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

public protocol SnapNavigationProvider {
	
	associatedtype Screen: SnapNavigationScreen
	
	var initialSelection: Screen { get }
	
	var selectableScreens: [Screen] { get }
	
	func parent(of screen: Screen) -> Screen?
	
}
