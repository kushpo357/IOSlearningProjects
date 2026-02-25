//
//  DemoCheckViewController.swift
//  addressBar
//
//  Created by Om Patil on 25/02/26.
//

import UIKit
import Foundation

final class DemoCheckViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(DemoCollectionViewCell.self, forCellWithReuseIdentifier: "democellID")
        return cv
    }()
    
    let array = ["adsefsrghgfrdfdgfhftrfghtrk", "adsefsrghgfrdfdgfhftrfghtrk", "adsefsrghgfrdfdgfhftrfghtrk", "adsefsrgh","adsefsrghgfrdfdgfhftrfghtrkfhftrfghtrkfhftrfghtrkadsefsrghgfrdfdgfhftrfghtrkfhftrfghtrkfhftrfghtrk", "adsefsrghgfrdfdgfhftrfghtrk", "adsefsrghgfrdfdgfhftrfghtrk"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView(){
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension DemoCheckViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "democellID", for: indexPath) as? DemoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.stringLabel.text = array[indexPath.row]
        return cell
    }
}


final class DemoCollectionViewCell: UICollectionViewCell {
    
    lazy var stringLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(stringLabel)
        NSLayoutConstraint.activate([
            stringLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            stringLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            stringLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            stringLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10)
        ])
    }
}
