//
//  self.swift
//  addressBar
//
//  Created by Om Patil on 24/02/26.
//

import UIKit

class IconLabelView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(icon: String, text: String, textColor: UIColor = .black, backgroundColor: UIColor = .white, hasPadding: Bool = false) {
        iconImageView.image = UIImage(systemName: icon)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        textLabel.text = text
        textLabel.textColor = textColor
        self.backgroundColor = backgroundColor
        
        if hasPadding {
            stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        }
    }
}
class AddressCardView : UIView {
    
//    let cardView = UIView()
    private let dividerView = UIView()
    //Labels
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    private let deliveryLabel = UILabel()
    
    //Buttons
    private let deleteButton = UIButton()
    private let editButton = UIButton()
    
    //views
    private let detailStack = UIStackView()
    private let infoStack = UIStackView()
    private let buttonStack = UIStackView()
    private let mainStack = UIStackView()
    private let addressStack = UIStackView()
    private let arrowImage = UIImageView()
    private let modifyStack = UIStackView()
    private let comboStack = UIStackView()
    private let separatorView1 = UIView()
    private let separatorView2 = UIView()
    private let nameView = IconLabelView()
    private let phoneView = IconLabelView()
    private let homeView = IconLabelView()
    
    init() {
        super.init(frame: .zero)
        // your setup goes here
        
        setupUI()
        setupConstraints()
    }
    
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}

private extension AddressCardView {

    
    //function to give dotted-underlined text
    func dottedUnderline(text: String) -> NSAttributedString {
        
        let UnderlinedAttr = NSAttributedString(string: "\(text)", attributes: [
            .underlineStyle: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.black,
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 16),
            .baselineOffset: 8
        ])

        return UnderlinedAttr
    }
    
    func setupUI() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 16
        self.layer.borderColor = UIColor(red: 0.80, green: 0.80, blue: 0.90, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
        
        mainStack.axis = .vertical
        mainStack.distribution = .fill
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainStack)
        
        dividerView.backgroundColor = .systemGray4
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "16 Cambridge Road, 16, Cambridge Rd, Halasuru, Cambridg Layout, Jogupalya, Bengaluru, Karnataka 560058, India ;alsjkdhflajhdf;lakds ;laksd;lkahs;dlfha;sldkfhalskdfhjasjjjjjjja;lsdjhfa;lhdsf;lka"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.layer.shadowOpacity = 0.1
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        addressLabel.text = "16 Cambridge Road, 16, Cambridge Rd, Halasuru, Cambridg Layout, Jogupalya, Bengaluru, Karnataka 560058, India ;alsjkdhflajhdf;lakds ;laksd;lkahs;dlfha;sldkfhalskdfhjasjjjjjjja;lsdjhfa;lhdsf;lka"
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.layer.shadowOpacity = 0.1
        addressLabel.textColor = .systemGray2
        addressLabel.numberOfLines = 0
        
        comboStack.translatesAutoresizingMaskIntoConstraints = false
        comboStack.distribution = .fill
        comboStack.spacing = 4
        comboStack.alignment = .top
        comboStack.axis = .vertical
        [titleLabel, addressLabel].forEach { comboStack.addArrangedSubview($0) }
        
        arrowImage.image = UIImage(systemName: "chevron.right")
        arrowImage.tintColor = .black
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.setContentHuggingPriority(.required, for: .horizontal)
        arrowImage.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addressStack.axis = .horizontal
        addressStack.distribution = .fill
        addressStack.alignment = .top
        addressStack.spacing = 8
        [comboStack, arrowImage].forEach { addressStack.addArrangedSubview($0) }
        
        nameView.configure(icon: "person", text: "My name")
        phoneView.configure(icon: "phone", text: "7983798737")
        homeView.configure(icon: "house", text: "HOME", backgroundColor: .systemGray5, hasPadding: true)
        homeView.layer.cornerRadius = 12
        homeView.clipsToBounds = true
        phoneView.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
        nameView.setContentCompressionResistancePriority(UILayoutPriority(750), for: .horizontal)
        homeView.setContentCompressionResistancePriority(UILayoutPriority(250), for: .horizontal)
        
        
        separatorView1.setContentCompressionResistancePriority(.required, for: .horizontal)
        separatorView2.setContentCompressionResistancePriority(.required, for: .horizontal)
        separatorView1.translatesAutoresizingMaskIntoConstraints = false
        separatorView1.backgroundColor = .black
        separatorView2.translatesAutoresizingMaskIntoConstraints = false
        separatorView2.backgroundColor = .black
        
        detailStack.axis = .horizontal
        detailStack.distribution = .equalSpacing
        detailStack.spacing = 8
        [nameView, separatorView1, phoneView, separatorView2, homeView].forEach { detailStack.addArrangedSubview($0) }
        
        
        infoStack.distribution = .fill
        infoStack.axis = .vertical
        infoStack.spacing = 8
        [addressStack, detailStack].forEach {
            infoStack.addArrangedSubview($0)
        }
       
        deliveryLabel.text = "   Next day delivery"
        deliveryLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        deliveryLabel.textColor = UIColor(red: 0.1, green: 0.72, blue: 0.35, alpha: 1.0)
        deliveryLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryLabel.backgroundColor = UIColor(red: 0.85, green: 0.97, blue: 0.88, alpha: 1.0)
        deliveryLabel.layer.cornerRadius = 12
        deliveryLabel.clipsToBounds = true

        deleteButton.setAttributedTitle(dottedUnderline(text: "Delete"), for: .normal)
        editButton.setAttributedTitle(dottedUnderline(text: "Edit"), for: .normal)
        
        modifyStack.axis = .horizontal
        modifyStack.distribution = .fill
        modifyStack.alignment = .center
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fill
        buttonStack.alignment = .center
        buttonStack.spacing = 16
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        [deleteButton, editButton].forEach { buttonStack.addArrangedSubview($0) }
        [deliveryLabel, spacer, buttonStack].forEach { modifyStack.addArrangedSubview($0) }
    
        [infoStack, dividerView, modifyStack].forEach { mainStack.addArrangedSubview($0) }
        
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            separatorView1.widthAnchor.constraint(equalToConstant: 1),
            separatorView2.widthAnchor.constraint(equalToConstant: 1),
            homeView.widthAnchor.constraint(equalToConstant: 80),
            homeView.heightAnchor.constraint(equalToConstant: 28),
            deliveryLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.5)
            ,
            deliveryLabel.heightAnchor.constraint(equalToConstant: 28),
            deleteButton.heightAnchor.constraint(equalToConstant: 28),
            editButton.heightAnchor.constraint(equalToConstant: 28),
            buttonStack.heightAnchor.constraint(equalToConstant: 28),
            modifyStack.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
