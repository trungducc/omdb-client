//
//  MovieCell.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .red
    }
    
    func configure(with movie: Movie) {}
}
