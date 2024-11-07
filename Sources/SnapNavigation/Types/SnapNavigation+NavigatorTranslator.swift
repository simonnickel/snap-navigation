//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Observation

extension SnapNavigation {
	
	@MainActor
	@Observable
	public class NavigatorTranslator {
		let translationNavigateTo: (_ destination: any SnapNavigationDestination) -> Void
		let translationPresent: (_ destination: any SnapNavigationDestination, _ style: PresentationStyle?) -> Void
		let translationDismissCurrentModal: () -> Void
		let translationDismissModals: () -> Void
		let translationPopCurrentToRoot: () -> Void
		
		public init(
			navigateTo: @escaping (_ destination: any SnapNavigationDestination) -> Void,
			present: @escaping (_ destination: any SnapNavigationDestination, _ style: PresentationStyle?) -> Void,
			dismissCurrentModal: @escaping () -> Void,
			dismissModals: @escaping () -> Void,
			popCurrentToRoot: @escaping () -> Void
		) {
			self.translationNavigateTo = navigateTo
			self.translationPresent = present
			self.translationDismissCurrentModal = dismissCurrentModal
			self.translationDismissModals = dismissModals
			self.translationPopCurrentToRoot = popCurrentToRoot
		}
		
		public func navigate(to destination: any SnapNavigationDestination) {
			translationNavigateTo(destination)
		}
		
		public func present(destination: any SnapNavigationDestination, style styleOverride: PresentationStyle? = nil) {
			translationPresent(destination, styleOverride)
		}
		
		public func dismissCurrentModal() {
			translationDismissCurrentModal()
		}
		
		public func dismissModals() {
			translationDismissModals()
		}
		
		public func popCurrentToRoot() {
			translationPopCurrentToRoot()
		}
		
		// TODO: translation to open window
		
	}
	
}

extension SnapNavigation.Navigator {
	
	internal var translator: SnapNavigation.NavigatorTranslator {
		SnapNavigation.NavigatorTranslator(
			navigateTo: { destination in
				if let destination = self.provider.translate(destination) {
					self.navigate(to: destination)
				}
			},
			present: { destination, style in
				if let destination = self.provider.translate(destination) {
					self.present(destination: destination, style: style)
				}
			},
			dismissCurrentModal: self.dismissCurrentModal,
			dismissModals: self.dismissModals,
			popCurrentToRoot: self.popCurrentToRoot
		)
	}
	
}
