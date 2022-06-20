//
//  PokeDetailVC.swift
//  PokeFinder
//
//  Created by River McCaine on 6/15/22.
//

import UIKit

class PokeDetailVC: UIViewController {
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokemonTypeLabel: UILabel!
    @IBOutlet weak var pokemonShinyButton: UIButton!
    
    
    var pokemon: Pokemon!
    var wasTapped = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    
    @IBAction func pokeAddButtonTapped(_ sender: Any) {
        
        Task {
            do {
                 let pokemon = try await NetworkManager.shared.getPokemon(from: pokemon.name)
                
                addPokemonToFavorites(pokemon: pokemon)
            } catch {
                if let error = error as? PokeError {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
    @IBAction func pokeSpriteTapped(_ sender: Any) {
        
        wasTapped == false ? downloadDefaultImage() : downloadShinyImage()
        
    }
    
    
    func updateUI() {
        guard let pokemon = pokemon else { return }
        
        let pokeType    = pokemon.types[0].type.name.capitalized
        let pokeID      = pokemon.id
        let pokeName    = pokemon.name.capitalized
        
        pokemonNameLabel.text = "#\(pokeID) \(pokeName)"
        pokemonTypeLabel.text = "\(pokeType) type"
        
        Task {
            let sprite = await NetworkManager.shared.downloadSprite(from: pokemon.sprites.frontDefault)
            pokemonSpriteImageView.image = sprite
        }
        
        
        switch pokeType {
        case "Water":
            view.backgroundColor = .systemBlue
        case "Fire":
            view.backgroundColor = .systemOrange
        case "Grass":
            view.backgroundColor = .systemGreen
        case "Rock":
            view.backgroundColor = .systemBrown
        case "Bug":
            view.backgroundColor = .systemGreen
        case "Ground":
            view.backgroundColor = .systemBrown
            
        default:
            view.backgroundColor = .gray
        }
        
    }
    
    func downloadDefaultImage() {
        guard let pokemon = pokemon else {
            return
        }
        Task {
            let defaultSprite = await NetworkManager.shared.downloadSprite(from: pokemon.sprites.frontDefault)
            pokemonSpriteImageView.image = defaultSprite
            
            wasTapped = true
        }
    }
    
    
    func downloadShinyImage() {
        guard let pokemon = pokemon else { return }
        Task {
            let shinySprite = await NetworkManager.shared.downloadSprite(from: pokemon.sprites.frontShiny)
            pokemonSpriteImageView.image = shinySprite
            
            wasTapped = false
        }
    }
    
    
    func addPokemonToFavorites(pokemon: Pokemon) {
        let favorite = Pokemon(id: pokemon.id, name: pokemon.name, sprites: pokemon.sprites, types: pokemon.types)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { error in
            
            guard let error = error else {
                DispatchQueue.main.async {
                    print("\(pokemon.name) has been added to favorites")
                }
                
                return
            }
            print(error.localizedDescription)
        }
    }
} // END OF CLASS
