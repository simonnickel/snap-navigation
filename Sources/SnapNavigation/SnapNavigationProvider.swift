//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

public protocol SnapNavigationProvider {
	
	associatedtype Screen: SnapNavigationScreen
	
	var initial: Screen { get }
	
	var screens: [Screen] { get }
	
	func parent(of screen: Screen) -> Screen?
	
	func subscreens(for screen: Screen) -> [Screen]
	
}
