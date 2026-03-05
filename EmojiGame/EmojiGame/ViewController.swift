//
//  ViewController.swift
//  EmojiGame
//
//  Created by Om Patil on 02/03/26.
//

import UIKit

class ViewController: UIViewController {

    private var viewIcon = UIImageView()
    private var iconStack = UIStackView()
    private var startButton = UIButton()
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    @objc func startButtonTapped() {
        let gameVC = GameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true, completion: nil)
    }
}


private extension ViewController {
    func setupUI() {
        viewIcon.translatesAutoresizingMaskIntoConstraints = false
        viewIcon.contentMode = .scaleAspectFit
        viewIcon.image = UIImage(named: "LoadIcon")
        
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor( .white, for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        iconStack.translatesAutoresizingMaskIntoConstraints = false
        iconStack.axis = .vertical
        iconStack.spacing = 10
        iconStack.distribution = .fill
        iconStack.alignment = .center
        iconStack.addArrangedSubview(viewIcon)
        iconStack.addArrangedSubview(startButton)
        
        self.view.addSubview(iconStack)
    }
        
    func setupConstraints() {
        NSLayoutConstraint.activate([
            viewIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewIcon.heightAnchor.constraint(equalToConstant: 100),
            viewIcon.widthAnchor.constraint(equalToConstant: 100),
            startButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}

