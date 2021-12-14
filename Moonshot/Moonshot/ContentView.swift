//
//  ContentView.swift
//  Moonshot
//
//  Created by Markus Ölhafen on 14.12.21.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @AppStorage("view") private var listView = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if listView == true {
                    ListView(missions: missions, astronauts: astronauts)
                        .padding([.horizontal, .bottom])
                } else {
                    GridView(missions: missions, astronauts: astronauts)
                        .padding([.horizontal, .bottom])
                }
            }
            .navigationTitle("Moonshot")
            .toolbar {
                Button {
                    withAnimation {
                        listView.toggle()
                    }
                } label: {
                    Image(systemName: listView ? "square.grid.2x2" : "list.dash")
                        .foregroundColor(.white)
                }
            }
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
