//
//  ContentView.swift
//  Units2
//
//  Created by Markus Ölhafen on 06.12.21.
//

import SwiftUI

struct ContentView: View {
    @State private var input = 10.0
    @State private var inputUnitIndex = 1
    @State private var outputUnitIndex = 2
    
    private let units: [(name: String, unit: UnitLength)] = [
        (name: "mm", unit: .millimeters),
        (name: "cm", unit: .centimeters),
        (name: "m", unit: .meters),
        (name: "in", unit: .inches),
        (name: "ft", unit: .feet),
        (name: "yrd", unit: .yards),
        (name: "mi", unit: .miles)
    ]
    
    var convertedUnit: Double {
        let input = Measurement(value: input, unit: units[inputUnitIndex].unit)
        return input.converted(to: units[outputUnitIndex].unit).value
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Choose input unit", selection: $inputUnitIndex) {
                        ForEach(0..<units.count) {
                            Text(self.units[$0].name)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Input")
                }
                Section {
                    Picker("Choose input unit", selection: $outputUnitIndex) {
                        ForEach(0..<units.count) {
                            Text(self.units[$0].name)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Output")
                }
                Section {
                    TextField("Enter your number", value: $input, format: .number)
                    Text("\(String(format: "%.2f", input)) \(units[inputUnitIndex].name) = \(String(format: "%.2f", convertedUnit)) \(units[outputUnitIndex].name) ")
                }
            } .navigationTitle("Units")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
