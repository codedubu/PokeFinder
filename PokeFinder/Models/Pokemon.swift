//
//  Pokemon.swift
//  PokeFinder
//
//  Created by River McCaine on 6/13/22.
//

import Foundation

struct Pokemon: Codable, Hashable {
    
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [SecondLevelObject]
} // END OF STRUCT

struct Sprites: Codable, Hashable {
    
    let frontDefault: String
    let frontShiny: String
} // END OF STRUCT

struct SecondLevelObject: Codable, Hashable {
    
    let type: Type
} // END OF STRUCT

struct Type: Codable, Hashable {
    
    let name: String
} // END OF STRUCT

