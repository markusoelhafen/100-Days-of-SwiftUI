//
//  ContentView.swift
//  Units
//
//  Created by Markus Ölhafen on 05.12.21.
//

import SwiftUI

struct ContentView: View {
    @State private var input = 0.0
    @State private var inputUnit = Units.meter
    @State private var outputUnit = Units.meter
    
    enum Units: String, CaseIterable {
        case meter = "Meter"
        case centimeter = "Centimeter"
        case millimeter = "Millimeter"
        case yards = "Yards"
        case feet = "Feet"
        case inch = "Inch"
    }
    
    var convertedUnit: Double {
        var baseUnit: Double = 0
        
        switch inputUnit {
        case .meter:
            baseUnit = input * 100
        case .centimeter:
            baseUnit = input * 10
        case .millimeter:
            baseUnit = input
        case .yards:
            baseUnit = input * 914.4
        case .feet:
            baseUnit = input * 304.8
        case .inch:
            baseUnit = input * 25.4
        }
        
        switch outputUnit {
        case .meter:
            return baseUnit / 100
        case .centimeter:
            return baseUnit / 10
        case .millimeter:
            return baseUnit
        case .yards:
            return baseUnit / 914.4
        case .feet:
            return baseUnit / 304.8
        case .inch:
            return baseUnit / 25.5
        }
    }
    
    var body: some View {
        
    NavigationView {
            Form {
                Section {
                    Picker("Choose input unit", selection: $inputUnit) {
                        ForEach(Units.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Input Unit")
                }
                
                Section {
                    Picker("Choose output unit", selection: $outputUnit) {
                        ForEach(Units.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Output Unit")
                }
                
                Section {
                    TextField("Enter number", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                    Text(convertedUnit, format: .number)
                } header: {
                    Text("Conversion Time")
                }
            }.navigationTitle("Units")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
