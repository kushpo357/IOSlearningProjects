//
//  ViewController.swift
//  cardUI
//
//  Created by Om Patil on 20/02/26.
//

import UIKit

class ViewController: UIViewController {
    
    let cardView = UIView()
    let cardImageView = UIImageView()
    let storeNameLabel = UILabel()
    let playIcon = UIImageView()
    let addressLabel = UILabel()
    let timeLabel = UILabel()
    let distanceLabel = UILabel()
    let callButton = UIButton()
    let BookButton = UIButton()
    
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
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 16
        self.view.addSubview(cardView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        cardView.addGestureRecognizer(tap)
        cardView.addSubview(cardImageView)
        
        cardImageView.layer.cornerRadius = 16
        cardImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cardImageView.clipsToBounds = true
        cardImageView.contentMode = .scaleAspectFill
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.image = UIImage(named: "StoreImage")
        cardImageView.addSubview(storeNameLabel)
        cardImageView.addSubview(playIcon)
        cardImageView.isUserInteractionEnabled = true
        
        storeNameLabel.text = "DLF Galleria"
        storeNameLabel.layer.shadowOpacity = 1.0
        storeNameLabel.textColor = .white
        storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        storeNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        playIcon.image = UIImage(systemName: "play.fill")
        playIcon.tintColor = .white
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.textColor = .darkGray
        addressLabel.numberOfLines = 2
        addressLabel.text = "SG 64, DLF Galleria, Phase 4, Gurugram,\nHaryana, 122009"
        cardView.addSubview(addressLabel)
        
        let clockIcon = UIImage(systemName: "clock")
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .darkGray
        let timeAttachment = NSTextAttachment()
        timeAttachment.image = clockIcon?.withTintColor(.darkGray)
        let timeAttrString = NSMutableAttributedString(attachment: timeAttachment)
        timeAttrString.append(NSAttributedString(string: " Open till 10:00 PM"))
        timeLabel.attributedText = timeAttrString
        cardView.addSubview(timeLabel)
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.4, alpha: 1.0)
        let navIcon = UIImage(systemName: "location.fill")
        let distanceAttachment = NSTextAttachment()
        distanceAttachment.image = navIcon?.withTintColor(UIColor(red: 0.0, green: 0.6, blue: 0.4, alpha: 1.0))
        let distanceAttrString = NSMutableAttributedString(attachment: distanceAttachment)
        distanceAttrString.append(NSAttributedString(string: " 0.9 km away"))
        distanceLabel.attributedText = distanceAttrString
        cardView.addSubview(distanceLabel)
        
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 1.0, alpha: 1.0)
        callButton.layer.cornerRadius = 12
        callButton.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        callButton.tintColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 1.0)
        cardView.addSubview(callButton)
        
        BookButton.translatesAutoresizingMaskIntoConstraints = false
        BookButton.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.3, alpha: 1.0)
        BookButton.layer.cornerRadius = 12
        BookButton.setTitle("Book Free Eye Test", for: .normal)
        BookButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        BookButton.setTitleColor(.white, for: .normal)
        cardView.addSubview(BookButton)
    }
    
    @objc func cardTapped() {
        let alert = UIAlertController(title: "alert", message: "You tapped the card!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func setupContraints(){
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            cardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 400),
            
            cardImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            cardImageView.heightAnchor.constraint(equalToConstant: 200),
            
            storeNameLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 10),
            storeNameLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: -10),
            
            playIcon.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            playIcon.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: -10),
            playIcon.heightAnchor.constraint(equalToConstant: 20),
            playIcon.widthAnchor.constraint(equalToConstant: 20),
            
            addressLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 10),
            addressLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            timeLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            distanceLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            distanceLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 16),
            
            callButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            callButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            callButton.heightAnchor.constraint(equalToConstant: 50),
            callButton.widthAnchor.constraint(equalToConstant: 50),
            
            BookButton.leadingAnchor.constraint(equalTo: callButton.trailingAnchor, constant: 10),
            BookButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            BookButton.centerYAnchor.constraint(equalTo: callButton.centerYAnchor),
            BookButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

import SwiftUI

#Preview {
    ViewController()
}
