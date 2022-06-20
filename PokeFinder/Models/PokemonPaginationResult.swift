//
//  PokemonPaginationResult.swift
//  PokeFinder
//
//  Created by River McCaine on 6/14/22.
//

import Foundation

struct PokemonPaginationResult: Codable, Hashable {
    
    let results: [PokemonResult]
} // END OF STRUCT

struct PokemonResult: Codable, Hashable {
    
    let name: String
    let url: URL
} // END OF STRUCT
