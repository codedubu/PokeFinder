//
//  PokemonCell.swift
//  PokeFinder
//
//  Created by River McCaine on 6/14/22.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    static let reuseID      = "PokemonCell"
    let pokemonImageView    = PFPokemonImageView(frame: .zero)
    let pokemonNameLabel    = PFTitleLabel(textAlignment: .center, fontSize: 16)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(pokemon: Pokemon) {
        let url = pokemon.sprites.frontDefault
        
        pokemonImageView.downloadImage(fromURL: url )
        pokemonNameLabel.text = "#\(pokemon.id) \(pokemon.name.capitalized)"
    }
    
    
    private func configure() {
        addSubviews(pokemonImageView, pokemonNameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            pokemonImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            pokemonImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            pokemonImageView.heightAnchor.constraint(equalTo: pokemonImageView.widthAnchor),
            
            pokemonNameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 12),
            pokemonNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            pokemonNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
} // END OF CLASS 
