//
//  PFPokemonImageView.swift
//  PokeFinder
//
//  Created by River McCaine on 6/14/22.
//

import UIKit

class PFPokemonImageView: UIImageView {

    let cache               = NetworkManager.shared.cache
    let placeholderImage    = Images.placeHolder
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(fromURL url: String) {
        Task { image = await NetworkManager.shared.downloadSprite(from: url) ?? placeholderImage }
    }
    
    
} // END OF CLASS
