//
//  HomeView1Controller.swift
//  guessEmojiCardGame
//
//  Created by Om Patil on 16/03/26.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let startButton = UIButton()
    private let appIcon = UIImageView()
    
    private let titleLabel = UILabel()
    private let viewModel = GameViewModel()
    private let timerLabel = UILabel()
    private let questionCard = UILabel()
    private let backButton = UIButton()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupHomeUI()
        setupGameUI()
        setupConstraints()
        showHomeState()
    }
}

private extension HomeViewController {
    
    func showHomeState() {
        view.backgroundColor = .white
        [titleLabel, timerLabel, questionCard, collectionView, backButton].forEach { $0.isHidden = true }
        [appIcon, startButton].forEach { $0.isHidden = false }
    }
    
    func showGameState() {
        view.backgroundColor = .blue
        [appIcon, startButton].forEach { $0.isHidden = true }
        [timerLabel, questionCard, collectionView, backButton].forEach { $0.isHidden = false }
        viewModel.startGame()
        collectionView.reloadData()
    }
}

private extension HomeViewController {
    
    @objc func startButtonTapped() {
        showGameState()
    }
    
    @objc func backButtonTapped() {
        collectionView.visibleCells.compactMap { $0 as? EmojiCardCell }.forEach { $0.flipBack() }
        viewModel.stopWatch.stopStopWatch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showHomeState()
        }
    }
}
private extension HomeViewController {
    
    func setupHomeUI() {
        appIcon.image = UIImage(named: "gameAppIcon")
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appIcon)
        
        startButton.setTitle("Start Game", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
    }
    
    func setupGameUI() {
        timerLabel.text = "00:00"
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        timerLabel.textColor = .white
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)
        
        titleLabel.text = "Find the Emoji!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        questionCard.textAlignment = .center
        questionCard.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        questionCard.textColor = .white
        questionCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionCard)
        
        questionCard.layer.cornerRadius = 12
        questionCard.layer.borderWidth = 10
        questionCard.layer.borderColor = UIColor.white.cgColor
        questionCard.backgroundColor = .white
        questionCard.clipsToBounds = true
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        collectionView.register(EmojiCardCell.self, forCellWithReuseIdentifier: EmojiCardCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Mark: Home
            appIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            appIcon.widthAnchor.constraint(equalToConstant: 100),
            appIcon.heightAnchor.constraint(equalToConstant: 100),
            
            //startButton
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 20),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            
            // Mark: Game
            //backButton
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            //timerLabel
            timerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.widthAnchor.constraint(equalToConstant: 300),
            timerLabel.heightAnchor.constraint(equalToConstant: 50),
            
            //questionCard
            questionCard.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            questionCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionCard.heightAnchor.constraint(equalToConstant: 50),
            questionCard.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.emojiArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
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
extension HomeViewController: GameViewModelDelegate {
    
    func didInitializeGame() {
        questionCard.text = viewModel.questionEmoji
    }
    
    func didStopGame() {
        let alert = UIAlertController(
            title: "🎉 You found it!",
            message: "Time: \(viewModel.stopWatch.elapsedTimeText)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.collectionView.visibleCells.compactMap { $0 as? EmojiCardCell }.forEach { $0.flipBack() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.viewModel.startGame()
                self?.collectionView.reloadData()
                self?.questionCard.text = self?.viewModel.questionEmoji
            }
        })
        present(alert, animated: true)
    }
    
    func didUpdateTimer(_ timeText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.timerLabel.text = timeText
        }
    }
}
