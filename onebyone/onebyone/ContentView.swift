//
//  ContentView.swift
//  onebyone
//
//  Created by Markus Ölhafen on 10.12.21.
//

import SwiftUI

struct RegularText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .heavy, design: .rounded))
    }
}

struct Headline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30, weight: .heavy, design: .rounded))
    }
}

struct HugeText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 50, weight: .heavy, design: .rounded))
    }
}

struct PrimaryCTA: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding().background(.mint).foregroundColor(.white).cornerRadius(10)
    }
}

struct WiggleButton: ViewModifier {
    let color: Color
    let size: Double
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(4)
            .rotationEffect(.degrees(Double.random(in: -2...2)))
        
    }
}

struct Grid<Content: View>: View {
    var content: (Int) -> Content
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(1..<11) { item in
                content(item)
            }
        }
    }
    
    init(@ViewBuilder content: @escaping (Int) -> Content) {
        self.content = content
    }
    
}

struct ContentView: View {
    // settings
    @State private var settingsVisible = false
    @State private var questionAmount = 10
    @State private var timesTable = 5
    
    // game
    @State private var showSuccess = false
    @State private var questions = [(q: String, a: Int)]()
    @State private var currentQuestion = (q: "", a: 0)
    @State private var currentPossibleAnswers = [Int]()
    @State private var turns = 0 {
        didSet {
            if turns == questionAmount {
                withAnimation {
                    showSuccess = true
                }
            } else {
                withAnimation {
                    showSuccess = false
                }
            }
        }
    }
    @State private var errors = 0
    
    
    var body: some View {
        ZStack {
            Color.mint
                .ignoresSafeArea()
            
            // Content goes here
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation { settingsVisible.toggle() }
                        
                    } label: {
                        Image(systemName: "gearshape.fill").font(.title).foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Group {
                    Text("\(currentQuestion.q) = ?").modifier(HugeText()).foregroundColor(.white)
                        .padding(.bottom, 60)
                    
                    HStack(spacing: 20) {
                        ForEach(currentPossibleAnswers, id: \.self) { answer in
                            Button {
                                checkAnswer(answer: answer)
                            } label: {
                                Text("\(answer)")
                                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                            }
                            .modifier(WiggleButton(color: .orange, size: 100))
                        }
                    }
                }
                
                Spacer()
                Spacer()
                
            }
            
            if showSuccess {
            GeometryReader { geometry in
                Color.secondary
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        Text("Yay!").modifier(HugeText()).padding(.bottom, 20)
                        Text("You got \(turns - errors) out of \(turns) questions correct!").modifier(Headline()).multilineTextAlignment(.center)
                        Spacer()
                        Button {
                            startGame()
                            
                        } label: {
                            Text("Play again!").modifier(RegularText())
                        }
                        .modifier(PrimaryCTA())
                    }
                    .padding(40)
                    .frame(
                        maxWidth: geometry.size.width * 0.9,
                        maxHeight: geometry.size.height * 0.6,
                        alignment: .top)
                    .background(.white)
                    .cornerRadius(20)
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .transition(.scale)
                
            }
                
            }
            
//          Settings goes here
            BottomSheetView(isOpen: $settingsVisible) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation { settingsVisible.toggle() }
                    } label: {
                        Image(systemName: "xmark.circle.fill").font(.title).foregroundColor(.secondary)
                    }

                }
                
                VStack {
                    Text("Settings").modifier(Headline())
                    Text("Which table do you want to play?").multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    Grid { number in
                        Button {
                            timesTable = number
                        } label: {
                            Text("1 x \(number)").modifier(RegularText())
                                
                        }
                        .modifier(WiggleButton(color: timesTable == number ? .red : .blue, size: 65))
                    }
                    .padding(.bottom, 60)
                }
                
                
                Button {
                    withAnimation { settingsVisible.toggle() }
                    startGame()
                } label: {
                    Text("Play!".uppercased()).modifier(RegularText())
                }
                .modifier(PrimaryCTA())
                
            }
            .edgesIgnoringSafeArea(.all)
            
        }
        .onAppear {
            startGame()
        }
    }
    
    func generateQuestions() {
        // clear current Questions before generatig new ones
        questions.removeAll()
        
        for x in 1...10 {
            questions.append((
                q: "\(x) x \(timesTable)",
                a: (x * timesTable)
            ))
        }
    }
    
    func askQuestion() {
        currentQuestion = questions.randomElement() ?? (q: "", a: 0)
        
        generateAnswers()
    }
    
    func generateAnswers() {
        var answers = [currentQuestion.a]
        var possibleAnswers = [Int]()
        
        for i in 0..<questions.count {
            // add all possible answer in current
            // multiplication table to array,
            // except correct answer
            if(questions[i].a != currentQuestion.a) {
                possibleAnswers.append(questions[i].a)
            }
        }
        
        for _ in 1...2 {
            let rand = Int.random(in: 0..<possibleAnswers.count)
            answers.append(possibleAnswers[rand])
            possibleAnswers.remove(at: rand)
        }
        
        currentPossibleAnswers = answers.shuffled()
        
    }
    
    func checkAnswer(answer: Int) {
        if answer != currentQuestion.a {
            errors += 1
        }
        askQuestion()
        turns += 1
    }
    
    func startGame() {
        generateQuestions()
        askQuestion()
        turns = 0
        errors = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
