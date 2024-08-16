//
//  SnapNavigationItem.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI

public protocol SnapNavigationItem: Identifiable, Hashable {
	
	var label: any View { get }
	var destination: any View { get }
	
}
