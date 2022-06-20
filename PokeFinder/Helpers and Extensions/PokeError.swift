//
//  PokeError.swift
//  PokeFinder
//
//  Created by River McCaine on 6/13/22.
//

import Foundation

enum PokeError: String, Error {
    
    case invalidPokemon     = "This pokemon created an invalid request. Please try again"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case unableToFavorite   = "The data could not be favorited. Please try again."
    case alreadyFavorited   = "You've already favorited this Pokemon!"
} // END OF ENUM
