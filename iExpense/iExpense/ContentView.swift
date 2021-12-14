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
                        .onDelete { indexSet in
                            guard let firstIndex = indexSet.first else { return }
                            removeItems(for: expenses.items.filter {$0.type == type}[firstIndex].id)
                        }
                    } header: {
                        Text("\(type)")
                    }
                }
//                Button("Add Sample Data") {
//                    // DEMO DATA
//                    expenses.items.append(ExpenseItem(name: "Personal 1", type: "Personal", amount: 10.0))
//                    expenses.items.append(ExpenseItem(name: "Personal 2", type: "Personal", amount: 10.0))
//                    expenses.items.append(ExpenseItem(name: "Business 1", type: "Business", amount: 10.0))
//                    expenses.items.append(ExpenseItem(name: "Personal 3", type: "Personal", amount: 10.0))
//                    expenses.items.append(ExpenseItem(name: "Business 2", type: "Business", amount: 10.0))
//                    expenses.items.append(ExpenseItem(name: "Business 3", type: "Business", amount: 10.0))
//                }
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
    
    func removeItems(for id: UUID) {
        expenses.items.removeAll(where: {$0.id == id})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
