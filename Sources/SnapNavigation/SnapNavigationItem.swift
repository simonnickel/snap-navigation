//
//  SnapNavigationItem.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI

public protocol SnapNavigationItem: Identifiable, Hashable {
	
    var items: [Self] { get }
    var title: String { get }
    var label: any View { get }
    var destination: any View { get }

}
