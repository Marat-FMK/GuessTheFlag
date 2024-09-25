//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Marat Fakhrizhanov on 10.09.2024.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 70))
            .foregroundStyle( Color(red: 9/255, green: 37/255, blue: 239/255))
    }
}

extension View {
    func titleModifier() -> some View {
        modifier(Title())
    }
}

struct FlagImage: View {

    let number: Int
    let countries: [String]
    
    var body: some View {
        Image(countries[number])
            .clipShape(.capsule)
            .shadow(radius: 10)
    }
}


struct ContentView: View {
    @State private var countries = ["Estonia",  "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0 ... 2)
    
    @State private var showingScore = false
    @State private var scoreTitle = " "
    
    @State private var result = 0
    
    @State private var animation = false
    @State private var selectedFlag = 0
    
    var body: some View {
        ZStack{
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.25, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 500)
            .ignoresSafeArea()
            
            VStack{
                
                ProgressView(value: Float(result),total: 8 )
                
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                   
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
//                          .font(.largeTitle.weight(.semibold))
                            .titleModifier()
                    }
                    
                    ForEach(0..<3) { number in
                        
                        Button {
                            withAnimation( .interactiveSpring(duration: 2) ){
                               flagTapped(number)
                               }
                            
                        } label: {
                           FlagImage(number: number, countries: countries)
                        }
                        .rotation3DEffect(.degrees(animation && selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .blur(radius: animation && selectedFlag != number ? 2 : 0)
                        .opacity(animation && selectedFlag != number ? 0.25 : 1)
                        .scaleEffect(animation && selectedFlag != number ? 0.75 : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(result)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
                
            }
            .padding()
        }
        
        .alert(result < 8 ? scoreTitle : "Perfectly", isPresented: $showingScore) {
           
            if result < 8 {
                Button("Continue", action: askQuestion)
            } else {
                Button(action: { askQuestion(); result = 0 }, label: {
                    Text("RESET")
                })
            }
        } message: {
            Text("Your score is \(result)")
        }
      
    }
    
    private func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            result += 1
            animation = true
        } else {
            scoreTitle = "Wrong, it \(countries[number]) flag !"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showingScore = true
        }
        
    }
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animation = false
    }
}

#Preview {
    ContentView()
}
