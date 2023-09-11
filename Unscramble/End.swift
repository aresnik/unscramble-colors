//
//  End.swift
//  Unscramble Colors
//
//  Created by Alex Resnik on 2/14/23.
//

import SwiftUI

struct End: View {
    
    @StateObject private var viewModel = Model()
    @State var isActive : Bool = false
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        if isActive {
            Board()
        } else {
            Color.black
                .ignoresSafeArea()
                .overlay(
                VStack {
                    if idiom == .phone { endIphone }
                    if idiom == .pad { endIpad }
                } .onAppear(perform: viewModel.load)
            )
        }
    }
}

extension End {
    private var endIphone: some View {
        VStack {
            Text("Game Over")
                .font(.system(size: 50))
                .foregroundColor(.white)
            Spacer()
            HStack() {
                Text("Time: \(viewModel.timeCurrent)")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .frame(width: 170, alignment: .leading)
                Spacer()
                Text("Moves: \(viewModel.movesCurrent)")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .frame(width: 150, alignment: .leading)
            }
            Text("Best:")
                .font(.system(size: 25))
                .foregroundColor(.white)
                .padding()
            HStack() {
                Text("Time: \(viewModel.timeBest)")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .frame(width: 170, alignment: .leading)
                Spacer()
                Text("Moves: \(viewModel.movesBest)")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .frame(width: 150, alignment: .leading)
            }
            Spacer()
            Button(action: {
                isActive = true
                viewModel.shuffleBoard()
            }, label: {
                Text("Play Again")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Capsule()
                        .stroke(Color.white, lineWidth: 2.0)
                    )
            })
            Spacer()
        }
    }
}

extension End {
    private var endIpad: some View {
        VStack {
            Text("Game Over")
                .font(.system(size: 100))
                .foregroundColor(.white)
            Spacer()
            HStack() {
                Text("Time: \(viewModel.timeCurrent)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(width: 340, alignment: .leading)
                Spacer()
                Text("Moves: \(viewModel.movesCurrent)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(width: 300, alignment: .leading)
            }
            Text("Best:")
                .font(.system(size: 50))
                .foregroundColor(.white)
                .padding()
            HStack() {
                Text("Time: \(viewModel.timeBest)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(width: 340, alignment: .leading)
                Spacer()
                Text("Moves: \(viewModel.movesBest)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(width: 300, alignment: .leading)
            }
            Spacer()
            Button(action: {
                isActive = true
                viewModel.shuffleBoard()
            }, label: {
                Text("Play Again")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .padding(25)
                    .background(
                        Capsule()
                        .stroke(Color.white, lineWidth: 4.0)
                    )
            })
            Spacer()
        }
    }
}

struct End_Previews: PreviewProvider {
    static var previews: some View {
        End()
    }
}
