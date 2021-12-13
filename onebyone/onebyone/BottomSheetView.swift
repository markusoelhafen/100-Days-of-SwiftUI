//
//  BottomSheetView.swift
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

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let content: Content
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(width: Constants.indicatorWidth, height: Constants.indicatorHeight)
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            isOpen ? Color.secondary : Color.clear
            
            VStack(spacing: 0) {
                VStack {}
                .frame(
                    width: geometry.size.width,
                    height: isOpen ? 40 : geometry.size.height)
                
                VStack(spacing: 0) {
                    self.content
                }
                .padding(20)
                .padding(.bottom, 60)
                .frame(width: geometry.size.width, alignment: .top)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(Constants.radius)
            }
            .frame(
                height: geometry.size.height,
                alignment: isOpen ? .bottom : .top)
        }
    }
    
    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.content = content()
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(isOpen: .constant(false)) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}
