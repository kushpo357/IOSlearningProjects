//
//  GameViewModel.swift
//  guessEmojiCardGame
//
//  Created by Om Patil on 10/03/26.
//

import Foundation

protocol GameViewModelDelegate: AnyObject {
    func didInitializeGame()
    func didStopGame()
    func didUpdateTimer(_ timeText: String)
}

final class GameViewModel {
    
    private(set) var emojiArray: [EmojiItem] = []
    private let numberOfEmojis: Int = 9
    private(set) var stopWatch = StopWatch()
    weak var delegate: GameViewModelDelegate?
    var questionEmoji = ""
    
    func makeEmojiArray(){
        
        emojiArray = EmojiLoader.shared.loadEmoji()
        
        if emojiArray.count < numberOfEmojis {
            if emojiArray.isEmpty {
                emojiArray.append(EmojiItem(id: 0, emoji: "😂"))
            }
            
            var i = 0
            while emojiArray.count < numberOfEmojis {
                emojiArray.append(emojiArray[i])
                i += 1
            }
        }
        else {
            emojiArray = Array(emojiArray.prefix(numberOfEmojis))
        }
        
        emojiArray.shuffle()
    }
    
}

extension GameViewModel{
    func startGame() {
        makeEmojiArray()
        stopWatch.onTick = { [weak self] timeText in
            self?.delegate?.didUpdateTimer(timeText)
        }
        stopWatch.startStopWatch()
        let randomIndex = Int.random(in: 0..<numberOfEmojis)
        questionEmoji = emojiArray[randomIndex].emoji
        
        delegate?.didInitializeGame()
    }
    
    func endGame() {
        delegate?.didStopGame()
        stopWatch.stopStopWatch()
    }
}

final class StopWatch {
    
    private var startTime: Date?
    private var timer: Timer?
    private var isRunning: Bool = false
    private(set) var elapsedTime: TimeInterval = 0
    var onTick: ((String) -> Void)?
    
    func startStopWatch() {
        if isRunning {
            stopStopWatch()
        }
        else {
            startTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.elapsedTime = Date().timeIntervalSince(self.startTime ?? Date())
                self.onTick?(self.elapsedTimeText)
            }
            isRunning = true
        }
    }
    
    func stopStopWatch() {
        timer?.invalidate()
        isRunning = false
        timer = nil
        startTime = nil
        elapsedTime = 0
    }
    
    var elapsedTimeText: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}



final class EmojiLoader {
    
    static let shared = EmojiLoader()
    
    private init() {}
    
    func loadEmoji() -> [EmojiItem] {
        
        guard let url = Bundle.main.url(forResource: "Emojis", withExtension: "json") else {
            print("Could not find Emojis.json")
            
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let emojiData = try decoder.decode([EmojiItem].self, from: data)
            
            print("Flags loaded \(emojiData.count)")
            
            return emojiData
        }
        catch {
            print("Error loading flags: \(error)")
            return []
        }
    }
}
