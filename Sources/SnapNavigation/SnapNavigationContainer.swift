//
//  SnapNavigationContainer.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI

public enum SnapNavigationStyle {
	case tab, sidebar, adaptable, dynamic
}

public struct SnapNavigationContainer<Item: SnapNavigationItem>: View {
	
	private let items: [Item]
	
	private let style: SnapNavigationStyle
	
	public init(items: [Item], initial: Item?, style: SnapNavigationStyle) {
		self.items = items
		self.selection = initial ?? items.first
		self.style = style
	}
	
	@State private var selection: Item?
	
	public var body: some View {
		switch style {
			case .tab:
				tabView
					.tabViewStyle(.tabBarOnly)
				
			case .sidebar:
				splitView
				
			case .adaptable:
				tabView
					.tabViewStyle(.sidebarAdaptable)
				
			case .dynamic:
				tabView // Like SnapMatchingNavigation
		}
	}
	
	private var tabView: some View {
		
		TabView(selection: $selection) {
			
			ForEach(items) { item in
				
				Tab(value: item, role: nil) {
					NavigationStack {
						SnapNavigationItemScreen(item: item)
							.navigationDestination(for: Item.self) { item in
								SnapNavigationItemScreen(item: item)
							}
					}
				} label: {
					AnyView(item.label)
				}

			}
		}
		
	}
	
	private var splitView: some View {
		
		NavigationSplitView {
			List(items, id: \.self, selection: $selection) { item in
				AnyView(item.label)
			}
		} detail: {
			NavigationStack {
				if let selection {
					SnapNavigationItemScreen(item: selection)
						.navigationDestination(for: Item.self) { item in
							SnapNavigationItemScreen(item: item)
						}
				}
			}
		}

	}
}
