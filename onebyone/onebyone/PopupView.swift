//
//  PopupView.swift
//  onebyone
//
//  Created by Markus Ölhafen on 13.12.21.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
}

struct PopupView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let content: Content
    
    var body: some View {
        GeometryReader { geometry in
            isOpen ? Color.secondary : Color.clear
            
            VStack {
                self.content
            }
        }
    }
    
    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.content = content()
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(isOpen: .constant(true)) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}
