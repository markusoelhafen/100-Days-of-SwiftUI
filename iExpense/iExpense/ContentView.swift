//
//  ContentView.swift
//  iExpense
//
//  Created by Markus Ölhafen on 13.12.21.
//

import SwiftUI

struct CurrencyText: ViewModifier {
    let amount: Double
    
    var color: Color {
        if amount < 10 {
            return Color.red
        } else if amount < 100 {
            return Color.blue
        }
        
        return Color.green
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    private var itemTypes: [String] {
        Array(Set(expenses.items.map { $0.type} )).sorted()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(itemTypes, id: \.self) { type in
                    Section {
                        ForEach(expenses.items.filter { $0.type == type }) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                    .modifier(CurrencyText(amount: item.amount))
                            }
                        }
                        .onDelete(perform: removeItems)
                    } header: {
                        Text("\(type)")
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
