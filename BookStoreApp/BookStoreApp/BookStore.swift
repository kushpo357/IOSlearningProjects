//
//  BookStore.swift
//  BookStoreApp
//
//  Created by Om Patil on 16/03/26.
//

import Foundation

class BookStore {
    private(set) var books: [Book] = []
    
    init() {
        load()
    }
    
    private func load() {
        do {
            let url = Bundle.main.url(forResource: "BookData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            books = try JSONDecoder().decode([Book].self, from: data)
            print("Books loaded: \(books.count)")
        } catch {
            print("Failed to load books: \(error)")
            books = []
        }
    }
    
}
