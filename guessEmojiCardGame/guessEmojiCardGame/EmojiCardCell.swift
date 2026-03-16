//
//  Untitled.swift
//  guessEmojiCardGame
//
//  Created by Om Patil on 11/03/26.
//

import UIKit

final class EmojiCardCell: UICollectionViewCell {
    
    static let identifier = "EmojiCardCell"
    private var isFlipped: Bool = false
    private let emojiButton = UIButton()
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String) {
        emojiButton.setTitle(isFlipped ? emoji : "?", for: .normal)
    }
    
    func flipReveal(with emoji: String) {
        if isFlipped == false {
            UIView.transition(with: emojiButton,
                              duration: 0.4,
                              options: .transitionFlipFromRight,
                              animations: {
                self.emojiButton.setTitle(emoji, for: .normal)
            })
        }
        isFlipped = true
    }
    
    func flipBack() {
        UIView.transition(with: emojiButton,
                          duration: 0.4,
                          options: .transitionFlipFromLeft,
                          animations: {
            self.emojiButton.setTitle("?", for: .normal)
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isFlipped = false
        emojiButton.setTitle("?", for: .normal)
    }
}

private extension EmojiCardCell {
    
    func setupUI() {
        emojiButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        emojiButton.backgroundColor = .white
        emojiButton.layer.cornerRadius = 8
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        emojiButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        emojiButton.setTitleColor(.black, for: .normal)
        contentView.addSubview(emojiButton)
    }
    
    @objc private func buttonTapped() {
        onTap?()
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            emojiButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
