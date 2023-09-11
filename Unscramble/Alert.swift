//
//  Alert.swift
//  Unscramble Colors
//
//  Created by Alex Resnik on 2/21/23.
//

import SwiftUI

struct Alert: View {
    
    @StateObject private var viewModel = Model()
    @State var isActive: Bool = false
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        if isActive {
            End()
        } else {
            VStack {
                if idiom == .phone { alertIphone }
                if idiom == .pad { alertIpad }
            }
        }
    }
}

extension Alert {
    private var alertIphone: some View {
        VStack {
            Text("SOLVED!")
                .font(.system(size: 25))
                .foregroundColor(.white)
                .padding()
            Button("OK") {
                isActive = true
            }
            .font(.system(size: 20))
            .foregroundColor(.white)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.white, lineWidth: 2)
            )
        }
        .padding()
        .frame(width: 250, height: 250)
        .background(.black)
        .cornerRadius(12)
        .onAppear(perform: viewModel.playSoundTada)
    }
}

extension Alert {
    private var alertIpad: some View {
        VStack {
            Text("SOLVED!")
                .font(.system(size: 50))
                .foregroundColor(.white)
                .padding(35)
            Button("OK") {
                isActive = true
            }
            .font(.system(size: 40))
            .foregroundColor(.white)
            .padding(25)
            .overlay(
                RoundedRectangle(cornerRadius: 45)
                    .stroke(.white, lineWidth: 4)
            )
        }
        .padding()
        .frame(width: 500, height: 500)
        .background(.black)
        .cornerRadius(24)
        .onAppear(perform: viewModel.playSoundTada)
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        Alert()
    }
}

