//
//  BookViewModel.swift
//  BookStoreApp
//
//  Created by Om Patil on 17/03/26.
//

import Foundation

protocol BookViewModelDelegate: AnyObject {
    func didTapWishlist(for book: Book)
}

class BookViewModel {
    private let bookStore = BookStore()
    var selectedTags = [BookTag]()
    var selectedSort: SortOption?
    private(set) var chips: [String] = ["All"] + BookTag.allCases.map { $0.rawValue }
    var searchQuery: String = ""
    
    var displayedBooks: [Book] {
        let filtered = bookStore.books.filter { Set(selectedTags).isSubset(of: Set($0.tags)) }
        
        let searched = searchQuery.isEmpty ? filtered : filtered.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.author.localizedCaseInsensitiveContains(searchQuery)
        }
        
        guard let sort = selectedSort else { return searched }
        return sort.apply(to: searched)
    }
    
    var wishlistBooks: [Book] {
        
        let filtered = bookStore.books.filter { WishlistManager.shared.isInWishlist(bookID: $0.id) && Set(selectedTags).isSubset(of: Set($0.tags)) }
        
        guard let sort = selectedSort else { return filtered }
        return sort.apply(to: filtered)
    }
}
