//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Markus Ölhafen on 06.12.21.
//

import SwiftUI

struct FlagImage: View {
    var imgSrc: String
    
    var body: some View {
        Image(imgSrc)
            .renderingMode(.original)
            .cornerRadius(10)
            .shadow(color: .secondary, radius: 5)
    }
}

struct ContentView: View {
    @State private var showingError = false
    @State private var showingResult = false
    @State private var flagTappedName = ""
    @State private var score = 0
    @State private var turns = 0 {
        didSet {
            if turns == 8 {
                showingResult = true
            }
        }
    }
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .mint]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.headline.weight(.regular))
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 50 ,weight: .heavy))
                    
                    Rectangle()
                        .frame(width: 300, height: 1, alignment: .center)
                        .foregroundColor(Color(hue: 0, saturation: 0, brightness: 1, opacity: 0.5))
                    
                    HStack {
                        Text("Score")
                            .foregroundColor(.white)
                            .font(.headline.weight(.regular))
                        Text("\(score)")
                            .foregroundColor(.white)
                            .font(.headline.weight(.heavy))
                        
                    }
                    .padding(.top, 20)
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        FlagImage(imgSrc: countries[number])
                    }
                }
                
            }
            
            
        }
        .alert("Your Score", isPresented: $showingResult) {
            Button("Start again", action: reset)
        } message: {
            Text("You got \(score) of 8 correct!")
        }
        .alert("Wrong", isPresented: $showingError) {
            Button("Ok", action: askQuestion)
        } message: {
            Text("This was not correct. This was the flag of \(flagTappedName)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            askQuestion()
        } else {
            showingError = true
            flagTappedName = countries[number]
        }
        
        turns += 1
    }
    
    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        score = 0
        turns = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
