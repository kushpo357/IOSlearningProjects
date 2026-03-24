//
//  BookCellModel.swift
//  BookStoreApp
//
//  Created by Om Patil on 24/03/26.
//

// BookCellModel.swift

import Foundation

struct BookCellModel {
    let id: Int
    let title: String
    let author: String
    let description: String
    let rating: String
    let price: String
    let imageName: String
    let tags: [BookTag]
    var isExpanded: Bool
    var isWishlisted: Bool
}

extension BookCellModel {
    static func make(from book: Book) -> BookCellModel {
        return BookCellModel(
            id: book.id,
            title: book.title,
            author: book.author,
            description: book.description,
            rating: "★ \(book.rating)",
            price: "₹\(Int(book.price))",
            imageName: book.imageName,
            tags: book.tags,
            isExpanded: false,
            isWishlisted: WishlistManager.shared.isInWishlist(bookID: book.id)
        )
    }
}
