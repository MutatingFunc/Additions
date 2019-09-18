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
struct ActivityIndicator: UIViewRepresentable {
	
	@Binding var isAnimating: Bool
	let style: UIActivityIndicatorView.Style
	
	func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
		return UIActivityIndicatorView(style: style)
	}
	
	func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
		isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
	}
}
#endif
