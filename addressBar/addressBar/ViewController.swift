//
//  ViewController.swift
//  addressBar
//
//  Created by Om Patil on 23/02/26.
//

import UIKit

class ViewController: UIViewController {
    
    let cardView = UIView()
    let dividerView = UIView()
    
    //Labels
    let titleLabel = UILabel()
    let addressLabel = UILabel()
    let nameLabel = UILabel()
    let numberLabel = UILabel()
    let seperatorLabel1 = UILabel()
    let seperatorLabel2 = UILabel()
    let homeLabel = UILabel()
    
    //Buttons
    let deleteButton = UIButton()
    let editButton = UIButton()
    
    //views
    let detailStack = UIStackView()
    let infoStack = UIStackView()
    let buttonStack = UIStackView()
    let mainStack = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUI()
        setupContraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

private extension ViewController {
    func setupUI() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 16
        self.view.addSubview(cardView)
        
        mainStack.axis = .vertical
        mainStack.distribution = .fill
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(mainStack)
        
        dividerView.backgroundColor = .systemGray4
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "The most common way to do it is, The only thing you have in mind is"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.layer.shadowOpacity = 0.1
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        addressLabel.text = "16 Cambridge Road, 16, Cambridge Rd, Halasuru, Cambridg Layout, Jogupalya, Bengaluru, Karnataka 560058, India"
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.layer.shadowOpacity = 0.1
        addressLabel.textColor = .systemGray2
        addressLabel.numberOfLines = 0
        
        nameLabel.text = "👤 My Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.text = "2123000008"
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        homeLabel.translatesAutoresizingMaskIntoConstraints = false
        homeLabel.text = "HOME"
        seperatorLabel1.text = "|"
        seperatorLabel1.translatesAutoresizingMaskIntoConstraints = false
        
        
        seperatorLabel2.text = "|"
        seperatorLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        detailStack.axis = .horizontal
        detailStack.distribution = .equalSpacing
        [nameLabel, seperatorLabel1, numberLabel, seperatorLabel2, homeLabel].forEach { detailStack.addArrangedSubview($0) }
        infoStack.distribution = .fill
        infoStack.axis = .vertical
        
        [titleLabel, addressLabel, detailStack].forEach {
            infoStack.addArrangedSubview($0)
        }
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fill
        buttonStack.spacing = 16
        buttonStack.alignment = .center
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        buttonStack.addArrangedSubview(spacer)
        
        [deleteButton, editButton].forEach { buttonStack.addArrangedSubview($0) }
        [infoStack, dividerView, buttonStack].forEach { mainStack.addArrangedSubview($0) }
    }
    
    func setupContraints(){
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            cardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}



