//
//  GameViewController.swift
//  guessEmojiCardGame
//
//  Created by Om Patil on 10/03/26.
//

import UIKit

final class GameViewController: UIViewController{
    
    private let viewModel = GameViewModel()
    private let timerLabel = UILabel()
    let questionCard = UILabel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor.blue.cgColor
//        tabBarController?.tabBar.isHidden = false
        viewModel.delegate = self
        setupUI()
        setupConstraints()
        viewModel.startGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.startGame()
    }
}
extension GameViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.emojiArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 4
        let rows = ceil(CGFloat(viewModel.emojiArray.count) / columns)
        let totalHSpacing = 10 * (columns - 1)
        let totalVSpacing = 10 * (rows - 1)
        let width = (collectionView.bounds.width - totalHSpacing) / columns
        let height = (collectionView.bounds.height - totalVSpacing) / rows
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCardCell.identifier, for: indexPath) as? EmojiCardCell else { return UICollectionViewCell() }
        
        cell.configure(with: viewModel.emojiArray[indexPath.item].emoji)
        
        
        cell.onTap = { [weak self] in
            guard let self else { return }
            
            let emoji = self.viewModel.emojiArray[indexPath.item].emoji
            cell.flipReveal(with: emoji)
            
            if emoji == self.viewModel.questionEmoji {
                self.viewModel.endGame()
            }
        }
        return cell
    }
}
private extension GameViewController {
    
    func setupUI() {
        
        timerLabel.text = "00:00"
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        timerLabel.textColor = .white
        
        questionCard.textAlignment = .center
        questionCard.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        questionCard.textColor = .white
        
        collectionView.register(EmojiCardCell.self, forCellWithReuseIdentifier: EmojiCardCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        [timerLabel, questionCard].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.widthAnchor.constraint(equalToConstant: 300),
            timerLabel.heightAnchor.constraint(equalToConstant: 50),
            
            questionCard.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            questionCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionCard.heightAnchor.constraint(equalToConstant: 50),
            questionCard.widthAnchor.constraint(equalToConstant: 100),
            
            collectionView.topAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}

extension GameViewController: GameViewModelDelegate {
    
    func didInitializeGame() {
        questionCard.text = viewModel.questionEmoji
    }
    
    func didStopGame() {
        let alert = UIAlertController(
            title: "🎉 You found it!",
            message: "Time: \(viewModel.stopWatch.elapsedTimeText)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) {
            [weak self] _ in
            self?.collectionView.visibleCells.compactMap { $0 as? EmojiCardCell }.forEach { $0.flipBack() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.collectionView.reloadData()
                self?.questionCard.text = self?.viewModel.questionEmoji
            }
            self?.viewModel.startGame()
        })
        present(alert, animated: true)
    }
     
    func didUpdateTimer(_ timeText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.timerLabel.text = timeText
        }
    }
}


/*
 
 RETAIN cycle ?
 
 Tab bar -
 
 unknown
 weak self needed
 DispatchQueue.main.async {
     self.timerLabel.text = timeText
 }
 
 alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
     self.viewModel.startGame()
     self.collectionView.reloadData()
 })
 
 
 
 */
