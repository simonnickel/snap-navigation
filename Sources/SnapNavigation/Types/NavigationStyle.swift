//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation
import SwiftUI

extension SnapNavigation {
	
	public enum NavigationStyle: Codable, Sendable {
		case single
		case tabsAdaptable
		
		static var fallback: Self { .single }
	}
	
}


// MARK: - Environment

internal extension EnvironmentValues {
	@Entry var navigationStyle: SnapNavigation.NavigationStyle? = nil
}


// MARK: - ViewModifier

public extension View {
	
	func navigationStyle(_ style: SnapNavigation.NavigationStyle?) -> some View {
		modifier(NavigationStyleModifier(style: style))
	}
	
}

fileprivate struct NavigationStyleModifier: ViewModifier {
	
	let style: SnapNavigation.NavigationStyle?

	func body(content: Content) -> some View {
		content
			.environment(\.navigationStyle, style)
	}
	
}

