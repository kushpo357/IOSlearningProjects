//
//  BookViewModel.swift
//  BookStoreApp
//
//  Created by Om Patil on 17/03/26.
//

protocol BookViewModelDelegate: AnyObject {
}

class BookViewModel {
    private let bookStore = BookStore()
    var selectedTags = [BookTag]()
    private(set) var wishlistBooks = [Book]()
    var selectedSort: SortOption?
    private(set) var chips: [String] = ["All"] + BookTag.allCases.map { $0.rawValue }
    
    var displayedBooks: [Book] {
        let filtered = bookStore.books.filter { Set(selectedTags).isSubset(of: Set($0.tags)) }
        guard let sort = selectedSort else { return filtered }
        return sort.apply(to: filtered)
     }
}
