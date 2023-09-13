//
//  Model.swift
//  Unscramble Colors
//
//  Created by Alex Resnik on 2/1/23.
//

import SwiftUI
import AVFAudio

final class Model: ObservableObject {
    
    @Published var movesCurrent: Int = 0
    @Published var timeCurrent: String = ""
    @Published var movesBest: Int = 0
    @Published var timeBest: String = ""
    @Published var time: String = "00:00:00"
    @Published var moves: Int = 0
    @Published var solved: Bool = false
    @Published var overLay: [Rectangle] = Array(repeating: Rectangle(), count: 54)
    @Published var color: [Color] = [
        .white,  .white,  .white,  .blue,   .blue,   .blue,
        .white,  .white,  .white,  .blue,   .blue,   .blue,
        .white,  .white,  .white,  .blue,   .blue,   .blue,
        .red,    .red,    .red,    .green,  .green,  .green,
        .red,    .red,    .red,    .green,  .green,  .green,
        .red,    .red,    .red,    .green,  .green,  .green,
        .orange, .orange, .orange, .yellow, .yellow, .yellow,
        .orange, .orange, .orange, .yellow, .yellow, .yellow,
        .orange, .orange, .orange, .yellow, .yellow, .clear ]

    private var timer: Timer = Timer()
    private var elapsed: Int = 0
    private var elapsedBest: Int = 0
    private var soundPlayer: AVAudioPlayer = AVAudioPlayer()
    private var defaults: UserDefaults = UserDefaults.standard
    
    func save() {
        NSUbiquitousKeyValueStore().set(moves, forKey: "movesCurrent")
        NSUbiquitousKeyValueStore().set(time, forKey: "timeCurrent")
        movesBest = Int(NSUbiquitousKeyValueStore().double(forKey: "movesBest"))
        if movesBest == 0 {
            movesBest = moves
        }
        if moves <= movesBest {
            NSUbiquitousKeyValueStore().set(moves, forKey: "movesBest")
        }
        elapsedBest = Int(NSUbiquitousKeyValueStore().double(forKey: "elapsedBest"))
        if elapsedBest == 0 {
            elapsedBest = elapsed
        }
        if elapsed <= elapsedBest {
            NSUbiquitousKeyValueStore().set(elapsed, forKey: "elapsedBest")
        }
    }
    
    func load() {
        movesCurrent = Int(NSUbiquitousKeyValueStore().double(forKey: "movesCurrent"))
        timeCurrent = NSUbiquitousKeyValueStore().string(forKey: "timeCurrent") ?? ""
        movesBest = Int(NSUbiquitousKeyValueStore().double(forKey: "movesBest"))
        elapsedBest = Int(NSUbiquitousKeyValueStore().double(forKey: "elapsedBest"))
        timeBest = createTimeString(seconds: elapsedBest)
    }
    
    func shuffleBoard() {
        color.shuffle()
        moves = 0
        elapsedTime()
    }
    
    func elapsedTime() {
        elapsed = 0
        time = "00:00:00"
        timer.invalidate()
        if !timer.isValid {
            timer.fire()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                elapsed += 1
                time = createTimeString(seconds: elapsed)
            }
        } else {
            timer.invalidate()
        }
    }
    
    func createTimeString(seconds: Int) -> String {
        let h: Int = seconds/3600
        let m: Int = (seconds/60) % 60
        let s: Int = seconds % 60
        let a = String(format: "%02u:%02u:%02u", h, m, s)
        return a
    }
    
    // Swap two pieces
    func move(i: Int) {
        let empty: Int = findEmpty()
        // Double check valid move
        if isNeighbor(i: i, empty: empty) {
            color.swapAt(empty, i)
            moves += 1
            playSound()
        }
    }
    
    func playSound() {
        do {
            let url =  Bundle.main.url(forResource: "move", withExtension: "mp3")
            soundPlayer = try AVAudioPlayer(contentsOf: url!)
            soundPlayer.volume = 0.2
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSoundTada() {
        do {
            let url =  Bundle.main.url(forResource: "tada", withExtension: "mp3")
            soundPlayer = try AVAudioPlayer(contentsOf: url!)
            soundPlayer.volume = 1.0
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // Check if neighbor
    func isNeighbor(i: Int, empty: Int) -> Bool {
        if abs(i - empty) == 1 || abs(i  - empty) == 6 {
            return true
        }
        return false
    }
    
    func findEmpty() -> Int {
        for i in 0..<color.count {
            if color[i] == .clear {
                return i
            }
        }
        return 0
    }
    
    func isSolved() {
        if  match(tileNumber: [  0,  1,  2,  6,  7,  8, 12, 13, 14 ]).count == 1 &&
            match(tileNumber: [  3,  4,  5,  9, 10, 11, 15, 16, 17 ]).count == 1 &&
            match(tileNumber: [ 18, 19, 20, 24, 25, 26, 30, 31, 32 ]).count == 1 &&
            match(tileNumber: [ 21, 22, 23, 27, 28, 29, 33, 34, 35 ]).count == 1 &&
            match(tileNumber: [ 36, 37, 38, 42, 43, 44, 48, 49, 50 ]).count == 1 &&
            match(tileNumber: [ 39, 40, 41, 45, 46, 47, 51, 52, 53 ]).count == 1 {
            save()
            solved = true
            timer.invalidate()
        }
    }
    
    func match(tileNumber: [Int]) -> [Color]{
        var matchColor: [Color]
        matchColor = compare(tileNumber: tileNumber)
        matchColor = matchColor.uniqued()
        matchColor = matchColor.filter { $0 != .clear }
        return matchColor
    }
    
    func compare(tileNumber: [Int]) -> [Color] {
        let colorList: [Color] = [ .white, .blue, .red, .green, .orange, .yellow, .clear ]
        var matchColor: [Color] = []
        for number in tileNumber {
            for colorLists in colorList {
                if color[number] == colorLists { matchColor.append(colorLists) }
            }
        }
        return matchColor
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

