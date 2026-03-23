//
//  BookViewModel.swift
//  BookStoreApp
//
//  Created by Om Patil on 17/03/26.
//

import Foundation

protocol BookViewModelDelegate: AnyObject {
}

class BookViewModel {
    private let bookStore = BookStore()
    var selectedTags = [BookTag]()
    private(set) var wishlistBooks = [Book]()
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
}
