//
//  ContentView.swift
//  WordScramble
//
//  Created by Markus Ölhafen on 09.12.21.
//

import SwiftUI

struct TextTitle: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 40, weight: .bold, design: .monospaced))
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct TextBody: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(.body, design: .monospaced))
            .bold()
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @FocusState private var wordInputIsFocused: Bool
    
    var body: some View {
        
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    TextBody("Find words in:")
                    HStack {
                        TextTitle(rootWord)
                        Spacer()
                        Button {
                          shuffle()
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.system(size: 20, weight: .heavy))
                        }
                        .foregroundColor(.black)
                        
                    }
                }
                .padding(20)
                
                ZStack {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.system(.title, design: .monospaced))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .focused($wordInputIsFocused)
                        .onSubmit { wordInputIsFocused = true }
                }
                .background(Color.white)
                .clipped()
                .shadow(color: .black, radius: 0, x: 6, y: 6)
                .border(.black, width: 5)
                .padding(.horizontal, 15)
                .onSubmit(addNewWord)
                
                HStack {
                    TextBody("Your score")
                    Spacer()
                    TextBody("\(score)")
                }
                .padding(20)
                
                ZStack {
                    Color.black
                    VStack {
                        ScrollView {
                            ForEach(usedWords, id: \.self) { word in
                                HStack {
                                    TextBody(word)
                                        .font(.system(size: 40))
                                    Spacer()
                                    TextBody("\(word.count)")
                                }
                                .padding(.vertical, 5)
                                .foregroundColor(.white)
                                
                            }
                        
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                }
                .background(.black)
                
            }
            .onAppear {
                startGame()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    wordInputIsFocused = true
                }
            }
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
        
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            newWord = ""
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You cant spell that word from '\(rootWord)'!")
            newWord = ""
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make up words")
            newWord = ""
            return
        }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Word to short", message: "Less than 3 characters are no word")
            newWord = ""
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        calculateScore()
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool {
        word.count >= 3
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func shuffle() {
        startGame()
        usedWords.removeAll()
        score = 0
        wordInputIsFocused = true
    }
    
    func calculateScore() {
        let amountOfWords = usedWords.count
        let amountOfCharacters = usedWords.joined().count
        
        score = (amountOfWords * 2) + amountOfCharacters
        return
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
