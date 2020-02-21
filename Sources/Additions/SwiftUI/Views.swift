//
//  Views.swift
//  
//
//  Created by James Froggatt on 18/09/2019.
//

#if canImport(UIKit) && canImport(SwiftUI) && !os(watchOS)
import SwiftUI
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public struct ActivityIndicator: UIViewRepresentable {
	var style: UIActivityIndicatorView.Style
	@Binding var isAnimating: Bool
	
	public init(style: UIActivityIndicatorView.Style, isAnimating: Binding<Bool> = .constant(false)) {
		self.style = style
		self._isAnimating = isAnimating
	}
	
	public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
		return UIActivityIndicatorView(style: style)
	}
	
	public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
		isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
	}
}
#endif
