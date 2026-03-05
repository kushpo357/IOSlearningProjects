//
//  GameViewController.swift
//  EmojiGame
//
//  Created by Om Patil on 02/03/26.
//

import UIKit
import Foundation


struct EmojiLoader {
    
    static func loadEmojis() -> [String] {
        // 1. Try to find the JSON file
        guard let url = Bundle.main.url(forResource: "emojis", withExtension: "json") else {
            print("❌ ERROR: Could not find emojis.json file")
            // ERROR HANDLING: Return fallback emojis
            return ["👿", "😇", "🤡", "🤠", "👻", "👽", "🤖", "🎃", "😺"]
        }
        
        do {
            // 2. Try to read the file
            let data = try Data(contentsOf: url)
            
            // 3. Try to parse the JSON
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: [String]],
               let emojis = json["emojis"] {
                print("✅ Successfully loaded \(emojis.count) emojis from JSON")
                return emojis
            } else {
                print("❌ ERROR: JSON format incorrect")
                // ERROR HANDLING: Return fallback emojis
                return ["👿", "😇", "🤡", "🤠", "👻", "👽", "🤖", "🎃", "😺"]
            }
        } catch {
            print("❌ ERROR: Could not read JSON file: \(error)")
            // ERROR HANDLING: Return fallback emojis
            return ["👿", "😇", "🤡", "🤠", "👻", "👽", "🤖", "🎃", "😺"]
        }
    }
}
struct GameState: Codable {
    var grid1Mappings: [Int: String?] = [:]
    var grid2Mappings: [Int: String?] = [:]
    var disabledButtonTags: [Int] = []
    var matchedEmojis: Set<String> = []
    var elapsedTime: TimeInterval = 0
    var systemTimeWhenLeft: TimeInterval = Date().timeIntervalSince1970
    var selectedButtonTag: Int? = nil
}

class StopWatchTimer {
    
    var stopwatchTimer: Timer?
    var stopwatchTime: TimeInterval = 0
    
    func startStopwatch( _ stopWatchLabel: UILabel? = nil) {

        stopStopwatch()
        stopwatchTime = 0
        updateStopwatchDisplay(stopWatchLabel)
        
        stopwatchTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] _ in
            self?.stopwatchTick(stopWatchLabel)
        }
    }

    func stopStopwatch() {
        stopwatchTimer?.invalidate()
        stopwatchTimer = nil
    }

    func stopwatchTick( _  stopWatchLabel: UILabel? = nil) {
        stopwatchTime += 1
        updateStopwatchDisplay(stopWatchLabel)
    }

    
    func updateStopwatchDisplay( _ stopWatchLabel: UILabel? = nil) {

        let minutes = Int(stopwatchTime) / 60
        let seconds = Int(stopwatchTime) % 60
        stopWatchLabel?.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

class GameViewController: UIViewController {
    
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.resetGame()
            })
            self.present(alert, animated: true)
        }
    
    private var gameState = GameState()
    private var timer = StopWatchTimer()
    private var stopwatchLabel: UILabel?
    private var emojiGrid1 = UIStackView()
    private var emojiGrid2 = UIStackView()
    private var selectedButton : UIButton? = nil
    private var selectedGrid : Int? = nil
    private var matchedEmojis = Set<String>()
    private let allEmojis = ["👿","😇","🤡","🤠","🤧","😷","🤒","🤕","🤢","🤮","😵","😶","🧟‍♂️","🧟‍♀️","🧜‍♂️","🧜‍♀️","🧓","👴","👵","🙍‍♂️","🙍‍♀️","🙎‍♂️","🙎‍♀️","🙅‍♂️","🙅‍♀️","🙆‍♂️","🙆‍♀️","💁‍♂️","💁‍♀️","🙋‍♂️","🙋‍♀️"]
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            timer.startStopwatch(stopwatchLabel)
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        gameState.elapsedTime = timer.stopwatchTime
        gameState.systemTimeWhenLeft = Date().timeIntervalSince1970
        gameState.matchedEmojis = matchedEmojis
        gameState.selectedButtonTag = selectedButton?.tag
        
        saveGameState()
        timer.stopStopwatch()
    }
    
    func restoreButton(from mappings: [Int: String?]) {
        for (tag, emoji) in mappings {
            guard let button = view.viewWithTag(tag) as? UIButton else { continue }
            
            button.setTitle(emoji, for: .normal)
            let isDisabled = gameState.disabledButtonTags.contains(tag)
            button.isEnabled = !isDisabled
            button.backgroundColor = button.isEnabled ? .systemBlue : .systemGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadGameState()
        timer.stopwatchTime = gameState.elapsedTime + (Date().timeIntervalSince1970 - gameState.systemTimeWhenLeft)
        gameState.elapsedTime = 0
        gameState.systemTimeWhenLeft = 0
        matchedEmojis = gameState.matchedEmojis
        
        restoreButton(from: gameState.grid1Mappings)
        restoreButton(from: gameState.grid2Mappings)
        
        if let selectedTag = gameState.selectedButtonTag {
                if let button = view.viewWithTag(selectedTag) as? UIButton, button.isEnabled {
                    selectedButton = button
                    selectedGrid = selectedTag / 100
                    button.backgroundColor = .systemRed
                }
        }
        
        timer.startStopwatch()
    }
    func restoreTimer(from savedState: GameState) {
        let currentSystemTime = Date().timeIntervalSince1970
        let timeAway = currentSystemTime - savedState.systemTimeWhenLeft
        
        let trueElapsedTime = savedState.elapsedTime + timeAway
        
        timer.stopwatchTime = trueElapsedTime
        timer.updateStopwatchDisplay(stopwatchLabel)
    }
    
    func resetGame() {
        
        UserDefaults.standard.removeObject(forKey: "savedGameState")
        gameState = GameState()
        
        matchedEmojis.removeAll()
        selectedButton = nil
        selectedGrid = nil
        
        let emojiSet = allEmojis.shuffled().prefix(9)
        
        emojiGrid1.removeFromSuperview()
        emojiGrid2.removeFromSuperview()
        
        emojiGrid1 = createEmojiGrid(emojis: emojiSet.shuffled(), gridTag: 1)
        emojiGrid2 = createEmojiGrid(emojis: emojiSet.shuffled(), gridTag: 2)
        
        view.addSubview(emojiGrid1)
        view.addSubview(emojiGrid2)
        
        setupConstraints()
        timer.startStopwatch(stopwatchLabel)
        
        updateGameState()
        saveGameState()
    }
    
    func refreshContent() {
        timer.stopStopwatch()
        let time = stopwatchLabel?.text ?? "00:00"
        self.showAlert(title: "You won", message: "Game Completed in time : \(time)")
    }
    @objc func handleEmojiTap( _ sender : UIButton){
        
        if selectedButton != nil {
            guard selectedGrid != sender.tag/100 && selectedButton!.currentTitle! == sender.currentTitle! else {
                selectedButton?.backgroundColor = .systemBlue
                selectedButton = nil
                selectedGrid = nil
                return
            }
            
            gameState.disabledButtonTags.append(sender.tag)
            gameState.disabledButtonTags.append(selectedButton!.tag)
            gameState.matchedEmojis.insert(sender.currentTitle!)
            matchedEmojis.insert(sender.currentTitle!)
            selectedButton?.backgroundColor = .systemGray
            sender.backgroundColor = .systemGray
            selectedButton?.isEnabled = false
            sender.isEnabled = false
            selectedButton = nil
            selectedGrid = nil
            
            if matchedEmojis.count == 9 {
                refreshContent()
            }
            else { saveGameState() }
        }
        else {
            selectedButton = sender
            selectedGrid = sender.tag/100
            selectedButton!.backgroundColor = .systemRed
        }
    }
}


private extension GameViewController {
    
    
    func saveGameState() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(gameState)
            UserDefaults.standard.set(data, forKey: "savedGameState")
            print("💾 Game saved successfully")
        } catch {
            print("❌ Failed to save game state: \(error)")
        }
    }

    func loadGameState() {
        guard let data = UserDefaults.standard.data(forKey: "savedGameState") else {
            print("📂 No saved game found")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            gameState = try decoder.decode(GameState.self, from: data)
            print("📂 Game loaded successfully")
        } catch {
            print("❌ Failed to load game state: \(error)")
        }
    }
    
    func updateGameState() {
            gameState.grid1Mappings.removeAll()
            for row in emojiGrid1.arrangedSubviews {
                guard let rowStack = row as? UIStackView else { continue }
                for button in rowStack.arrangedSubviews {
                    guard let emojiButton = button as? UIButton else { continue }
                    gameState.grid1Mappings[emojiButton.tag] = emojiButton.title(for: .normal)
                }
            }
            
            gameState.grid2Mappings.removeAll()
            for row in emojiGrid2.arrangedSubviews {
                guard let rowStack = row as? UIStackView else { continue }
                for button in rowStack.arrangedSubviews {
                    guard let emojiButton = button as? UIButton else { continue }
                    gameState.grid2Mappings[emojiButton.tag] = emojiButton.title(for: .normal)
                }
            }
            
            print("📝 Game state updated")
    }
    
    func createEmojiButton(emoji: String, tag: Int) -> UIButton {
            let button = UIButton()
            button.setTitle(emoji, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(handleEmojiTap), for: .touchUpInside)
            button.tag = tag
            return button
        }
        
        func createEmojiRow(emojis: [String], startIndex: Int, gridTag: Int, rowOffset: Int) -> UIStackView {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.alignment = .fill
            row.spacing = 10
            
            let button1 = createEmojiButton(
                emoji: emojis[startIndex],
                tag: (gridTag * 100) + rowOffset
            )
            let button2 = createEmojiButton(
                emoji: emojis[startIndex + 1],
                tag: (gridTag * 100) + rowOffset + 1
            )
            let button3 = createEmojiButton(
                emoji: emojis[startIndex + 2],
                tag: (gridTag * 100) + rowOffset + 2
            )
            
            row.addArrangedSubview(button1)
            row.addArrangedSubview(button2)
            row.addArrangedSubview(button3)
            
            return row
        }
        
        func createEmojiGrid(emojis: [String], gridTag: Int) -> UIStackView {
            let grid = UIStackView()
            grid.axis = .vertical
            grid.distribution = .fillEqually
            grid.alignment = .fill
            grid.spacing = 10
            grid.translatesAutoresizingMaskIntoConstraints = false
            
            let row1 = createEmojiRow(emojis: emojis, startIndex: 0, gridTag: gridTag, rowOffset: 0)
            let row2 = createEmojiRow(emojis: emojis, startIndex: 3, gridTag: gridTag, rowOffset: 3)
            let row3 = createEmojiRow(emojis: emojis, startIndex: 6, gridTag: gridTag, rowOffset: 6)
            
            grid.addArrangedSubview(row1)
            grid.addArrangedSubview(row2)
            grid.addArrangedSubview(row3)
            
            return grid
        }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = .monospacedDigitSystemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        stopwatchLabel = label
        
        let emojiSet = allEmojis.shuffled().prefix(9)
        let emojiSet1 = emojiSet.shuffled()
        emojiGrid1 = createEmojiGrid(emojis: emojiSet1, gridTag: 1)
        let emojiSet2 = emojiSet.shuffled()
        emojiGrid2 = createEmojiGrid(emojis: emojiSet2, gridTag: 2)
        
        updateGameState()
        view.addSubview(emojiGrid1)
        view.addSubview(emojiGrid2)
    }
        
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            stopwatchLabel!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stopwatchLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emojiGrid1.topAnchor.constraint(equalTo: stopwatchLabel!.bottomAnchor, constant: 20),
            emojiGrid1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emojiGrid1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emojiGrid1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            emojiGrid2.topAnchor.constraint(equalTo: emojiGrid1.bottomAnchor, constant: 20),
            emojiGrid2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emojiGrid2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emojiGrid2.heightAnchor.constraint(equalTo: emojiGrid1.heightAnchor)
        ])
    }
}
