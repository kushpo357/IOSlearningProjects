//
//  AddressCardCell.swift
//  addressBar
//
//  Created by Om Patil on 24/02/26.
//

import UIKit
class AddressCardCell : UICollectionViewCell {
    
    static let identifier: String = "AddressCardCell"
    private let addressCard = AddressCardView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddressCardCell {
    
    func setupUI() {
        contentView.addSubview(addressCard)
        addressCard.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
                addressCard.topAnchor.constraint(equalTo: contentView.topAnchor),
                addressCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                addressCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                addressCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        
    }
}
