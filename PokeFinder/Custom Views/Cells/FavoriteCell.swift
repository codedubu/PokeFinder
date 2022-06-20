//
//  FavoriteCell.swift
//  PokeFinder
//
//  Created by River McCaine on 6/17/22.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    static let reuseID      = "favoriteCell"
    let pokemonImageView    = PFPokemonImageView(frame: .zero)
    let pokemonLabel        = PFTitleLabel(textAlignment: .left, fontSize: 26)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(favorite: Pokemon) {
        pokemonLabel.text = favorite.name
        pokemonImageView.downloadImage(fromURL: favorite.sprites.frontDefault)
    }
    
    
    private func configure() {
        addSubviews(pokemonImageView, pokemonLabel)
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            pokemonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            pokemonImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 94),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 94),
            
            pokemonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            pokemonLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 24),
            pokemonLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            pokemonLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
} // END OF CLASS
