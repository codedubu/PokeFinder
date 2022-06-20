//
//  NetworkManager.swift
//  PokeFinder
//
//  Created by River McCaine on 6/13/22.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared           = NetworkManager()
    private let baseURL         = "https://pokeapi.co/api/v2"
    static let pokemonPerPage   = 50
    let decoder                 = JSONDecoder()
    let cache                   = NSCache<NSString, UIImage>()
    
    private init() { decoder.keyDecodingStrategy = .convertFromSnakeCase }
    
    
//    func getAllPokemon(page: Int) async throws -> [Pokemon] {
//        ///`Endpoint:`  = https://pokeapi.co/api/v2/pokemon/{id or name}
//        let endpoint = baseURL + "/pokemon?limit=\(NetworkManager.pokemonPerPage)&offset=\(page)"
//
//        guard let finalURL = URL(string: endpoint) else {
//
//            throw PokeError.invalidPokemon
//        }
//
//        let (data, response) = try await URLSession.shared.data(from: finalURL)
//
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//
//            throw PokeError.invalidPokemon
//        }
//
//        let paginationResult = try decoder.decode(PokemonPaginationResult.self, from: data)
//
//
//        var pokemonArray: [Pokemon] = []
//
//        for result in paginationResult.results {
//
//            try await pokemonArray.append(getPokemon(with: result.url))
//        }
//
//        return pokemonArray
//    }
//
        // taskGroup Version
        func getAllPokemon(page: Int) async throws -> [Pokemon] {
            let endpoint = baseURL + "/pokemon?limit=\(NetworkManager.pokemonPerPage)&offset=\(page)"
    
            guard let finalURL = URL(string: endpoint) else {
    
                throw PokeError.invalidPokemon
            }
    
            let (data, response) = try await URLSession.shared.data(from: finalURL)
    
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
    
                throw PokeError.invalidPokemon
            }
    
            let paginationResult = try decoder.decode(PokemonPaginationResult.self, from: data)
    
    
    
            var pokemonArray: [Pokemon] = []
    
            try await withThrowingTaskGroup(of: Pokemon.self, body: { group in
    
                for result in paginationResult.results {
    
                    group.addTask { [self] in
                    async let result = getPokemon(with: result.url)
    
                    return try await result
                    }
                }
    
                for try await result in group {
                    pokemonArray += [result]
                }
            })
            
            let sortedArray = pokemonArray.sorted(by: { $0.id < $1.id })
    
            return sortedArray
        }
    
    
    func getPokemon(with url: URL) async throws -> Pokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            
            throw PokeError.invalidResponse
        }
        
        return try decoder.decode(Pokemon.self, from: data)
    }
    
    
    func getPokemon(from name: String) async throws -> Pokemon {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(name)/"
        
        guard let finalURL = URL(string: endpoint) else {
            
            throw PokeError.invalidPokemon
        }
        
        let (data, response) = try await URLSession.shared.data(from: finalURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

            throw PokeError.invalidPokemon
        }
        
        return try decoder.decode(Pokemon.self, from: data)
    }
    
    
    func downloadSprite(from urlString: String) async -> UIImage? {
        
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else { return nil }
            
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
} // END OF CLASS
