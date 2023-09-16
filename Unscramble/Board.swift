//
//  Board.swift
//  Unscramble Colors
//
//  Created by Alex Resnik on 12/30/22.
//

import SwiftUI

struct Board: View {
    
    @StateObject private var viewModel = Model()
    @State var isActive: Bool = false
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        if isActive {
            End()
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    VStack(alignment: .center) {
                        if idiom == .phone { labelIphone }
                        if idiom == .pad { labelIpad }
                        VStack() {
                            ForEach(0..<9) { y in
                                HStack() {
                                    ForEach(0..<6) { x in
                                        let i: Int = x + y*6
                                        Rectangle()
                                            .foregroundColor(viewModel.color[i])
                                            .onTapGesture {
                                                viewModel.move(i: i)
                                                let _ = viewModel.isSolved()
                                            }
                                            .animation(.linear(duration: 0.2), value: viewModel.color)
                                    }
                                }
                            }
                        }.aspectRatio(CGSize(width: 600, height: 900), contentMode: .fit)
                    }.padding(.top, 20)
                     .onAppear(perform: viewModel.shuffleBoard)
                     .allowsHitTesting(!viewModel.solved)
                }.blur(radius: viewModel.solved ? 2 : 0)
                if viewModel.solved {
                    Alert()
                }
            }
//            .onAppear {
//                Task {
//                    await viewModel.authenticateUser()
//                }
//            }
        }
    }
}

extension Board {
    private var labelIphone: some View {
        HStack() {
            Spacer()
            Text("Time: \(viewModel.time)")
                .foregroundColor(.white)
                .font(.system(size: 25))
                .frame(width: 170, alignment: .leading)
            Spacer()
            Text("Moves: \(viewModel.moves)")
                .foregroundColor(.white)
                .font(.system(size: 25))
                .frame(width: 150, alignment: .leading)
            Spacer()
        }.frame(height: 20)
    }
}

extension Board {
    private var labelIpad: some View {
        HStack() {
            Spacer()
            Text("Time: \(viewModel.time)")
                .foregroundColor(.white)
                .font(.system(size: 35))
                .frame(width: 340, alignment: .leading)
            Spacer()
            Text("Moves: \(viewModel.moves)")
                .foregroundColor(.white)
                .font(.system(size: 35))
                .frame(width: 300, alignment: .leading)
            Spacer()
        }.frame(height: 20)
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        Board()
    }
}
