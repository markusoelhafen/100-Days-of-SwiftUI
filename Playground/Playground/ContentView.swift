//
//  ContentView.swift
//  Playground
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
                    self.indicator.padding()
                    self.content
                }
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

struct ContentView: View {
    @State private var showSheet = true
    
    var body: some View {
        ZStack {
            Color.mint
                .ignoresSafeArea()
            
            if showSheet {
                Color.secondary
                    .ignoresSafeArea()
            }
            
            Button("Open") {
                withAnimation {
                    showSheet.toggle()
                }
            }
            
            BottomSheetView(isOpen: $showSheet) {
                Button("Close") {
                    withAnimation {
                        showSheet.toggle()
                    }
                }
                Text("Foo")
                Text("Foo")
                Text("Foo")
            }
            .edgesIgnoringSafeArea(.all)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
