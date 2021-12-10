//
//  ContentView.swift
//  RPS
//
//  Created by Markus Ölhafen on 07.12.21.
//

import SwiftUI

struct DefaultText: View {
    var text: String
    
    var body: some View {
        Text(text.uppercased())
            .kerning(2)
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .heavy))
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct PlayerButton: View {
    let text: String
    
    var body: some View {
        Text(text)
        .font(.system(size: 54))
        .frame(width: 100, height: 100)
        .background(.red)
        .cornerRadius(20)
        .shadow(color: Color(hue: 1, saturation: 1, brightness: 0, opacity: 0.2), radius: 15)
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct SuccessView: View {
    let score: Int
    let buttonAction: () -> Void
    
    var body: some View {
        GeometryReader { metrics in
            Color.secondary
                .ignoresSafeArea()
            
            ZStack {
                VStack {
                    Spacer()
                    Text("🎉🎉🎉")
                        .font(.largeTitle)
                        .bold()
                    Text("Game over!")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.mint)
                    Spacer()
                    Text("Your total score is")
                        .font(.subheadline)
                        .bold()
                    Text("\(score)")
                        .font(.system(size: 60, weight: .heavy))
                        .foregroundColor(.mint)
                    Spacer()
                    Button {
                        buttonAction()
                    } label: {
                        Text("Play again!")
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Spacer()
                    
                }
                .frame(
                    width: metrics.size.width * 0.9,
                    height: metrics.size.height * 0.6)
                .background(.white)
                .cornerRadius(20)
                .shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.5), radius: 20)
            }
            .frame(
                width: metrics.size.width,
                height: metrics.size.height)
        }
    }
}

struct ContentView: View {
    @State private var showResult = false
    @State private var answerTapped = ""
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var turns = 0
    var maxTurns = 8
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let winningMoves = ["✋", "✌️", "✊"]
    let moves = ["✊", "✋", "✌️"]
    let losingMoves  = ["✌️", "✊", "✋"]
    
    enum Sign: String, CaseIterable {
        case rock = "✊"
        case paper = "✋"
        case scissors = "✌️"
    }
    
    var body: some View {
        ZStack {
            Color.indigo
                .ignoresSafeArea()
            
            VStack {
                 
                Spacer()
                
                VStack {
                    DefaultText("\(shouldWin ? "Win" : "Lose") against")
                        .padding(.bottom, 1)
                    Text("\(shouldWin ? losingMoves[correctAnswer] : winningMoves[correctAnswer])")
                        .font(.system(size: 54))
                }
                .padding(.bottom, 100)
                
                HStack(spacing: 15) {
                    ForEach(0..<moves.count) { number in
                        Button { checkToWin(number) }
                            label: { PlayerButton(moves[number]) }
                    }
                }
                
                Spacer()
                Text("Turn \( turns + 1 ) of \(maxTurns)")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .heavy))
                
                Spacer()
                
            }
            
            if(turns == maxTurns) {
                SuccessView(
                    score: score,
                    buttonAction: restartGame
                )
            }
            
        }
        
        
    }
    
    func checkToWin(_ number: Int) {
        print("Player: \(number) – Game: \(correctAnswer)")
        if number == correctAnswer {
            score += 1
        } else {
            score -= 1
        }
        turns += 1
        
        shuffle()
    }
    
    func restartGame() {
        score = 0
        turns = 0
        shuffle()
    }
    
    func shuffle() {
        correctAnswer = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
