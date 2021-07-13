//
//  Constants.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

enum Constants {
    enum String {
        static let filmsList = "Films list"
        static let enterFilmName = "Enter film's name"
        static let welcome = "Welcome 🍿"
        static let empty = "Look like our database doesn't have the film you are looking for 😥"
        static let errorOccurred = "Error occurred 😐"
    }
    
    enum Movies {
        static let spacing: CGFloat = 20
        static let cellRatio: CGFloat = 0.75
        static let loadMoreCellHeight: CGFloat = 60
        static let numberOfMoviesPerRow = 2
        
        static let firstPageIndex = 1
        static let searchDebounceTime = 0 // Milliseconds
    }
}
