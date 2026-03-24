//
//  WishlistViewController.swift
//  BookStoreApp
//
//  Created by Om Patil on 16/03/26.
//

import UIKit

final class WishlistViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let titleSeparator = UIView()
    private let emptyStateLabel = UILabel()
    private let viewModel = BookViewModel()
    private let filterButton = UIButton()
    private let filterPopup = FilterPopupView()
    private lazy var bookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32, height: 200)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        emptyStateLabel.isHidden = !WishlistManager.shared.checkIfEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookCollectionView.reloadData()
        emptyStateLabel.isHidden = !WishlistManager.shared.checkIfEmpty()
    }
    
    @objc func onFilterTapped() {
        print("Filter button tapped - current hidden: \(filterPopup.isHidden)") // Debug
        filterPopup.isHidden.toggle()
        view.bringSubviewToFront(filterPopup)
        print("Filter popup now hidden: \(filterPopup.isHidden)") // Debug
    }
}

private extension WishlistViewController {
    
    func setupUI() {
        view.backgroundColor = .parchmentColor
        titleLabel.text = "Wishlist"
        titleLabel.font = UIFont(name: "Georgia", size: 32)
        titleLabel.textColor = .inkColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleSeparator.backgroundColor = .pageColor
        titleSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateLabel.text = "No books wishlisted yet"
        emptyStateLabel.font = UIFont(name: "Georgia", size: 16)
        emptyStateLabel.textColor = .mutedInk
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        filterButton.tintColor = .sageColor
        filterButton.backgroundColor = .parchmentColor
        filterButton.layer.cornerRadius = 28
        filterButton.layer.shadowColor = UIColor.black.cgColor
        filterButton.layer.shadowOpacity = 0.15
        filterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterButton.layer.shadowRadius = 6
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.addTarget(self, action: #selector(onFilterTapped), for: .touchUpInside)
        filterPopup.translatesAutoresizingMaskIntoConstraints = false
        filterPopup.isHidden = true
        filterPopup.delegate = self
        
        bookCollectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.identifier)
        
        
        [titleLabel, titleSeparator, tagCollectionView, bookCollectionView, emptyStateLabel, filterButton, filterPopup].forEach { view.addSubview($0) }
        

        tagCollectionView.register(ChipCell.self, forCellWithReuseIdentifier: ChipCell.identifier)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            titleSeparator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            titleSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            filterButton.widthAnchor.constraint(equalToConstant: 56),
            filterButton.heightAnchor.constraint(equalToConstant: 56),
                            
            filterPopup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterPopup.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -12),
            
            filterPopup.widthAnchor.constraint(equalToConstant: 220),
            filterPopup.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            tagCollectionView.topAnchor.constraint(equalTo: titleSeparator.bottomAnchor, constant: 12),
            tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            bookCollectionView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 12),
            bookCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                            
        ])
    }
}


extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == bookCollectionView {
            return viewModel.wishlistBooks.count
        } else {
            return viewModel.chips.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == bookCollectionView {
            
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
                return UICollectionViewCell()
            }
            
            cell.delegate = self
            
            cell.configure(with: viewModel.wishlistBooks[indexPath.item])
            
            return cell
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipCell.identifier, for: indexPath) as? ChipCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModel.chips[indexPath.item])
            
            let chipTitle = viewModel.chips[indexPath.item]
            let isSelected: Bool

            if chipTitle == "All" {
                isSelected = viewModel.selectedTags.isEmpty
            } else if let tag = BookTag(rawValue: chipTitle) {
                isSelected = viewModel.selectedTags.contains(tag)
            } else {
                isSelected = false
            }

            cell.isChipSelected = isSelected
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == bookCollectionView {
            return CGSize(width: view.bounds.width - 32, height: 200)
        } else {
            return CGSize(width: 100, height: 32)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            let selected = viewModel.chips[indexPath.item]
            
            if selected == "All" {
                viewModel.selectedTags = []
            } else if let tag = BookTag(rawValue: selected) {
                if viewModel.selectedTags.contains(tag) {
                    viewModel.selectedTags.removeAll { $0 == tag }
                } else {
                    viewModel.selectedTags.append(tag)
                }
            }
            
            bookCollectionView.reloadData()
            tagCollectionView.reloadData()
            
        }
    }
}

extension WishlistViewController: FilterPopupDelegate {
    func didRemoveFilters() {
        viewModel.selectedSort = nil
        bookCollectionView.reloadData()
    }
    
    func didSelectSortOption(_ option: SortOption) {
        
        viewModel.selectedSort = option
        bookCollectionView.reloadData()
    }
}

extension WishlistViewController: BookCellDelegate {
    func didToggleWishlist() {
        bookCollectionView.reloadData()
        DispatchQueue.main.async { [weak self] in self?.emptyStateLabel.isHidden = !WishlistManager.shared.checkIfEmpty()
        }
    }
}
