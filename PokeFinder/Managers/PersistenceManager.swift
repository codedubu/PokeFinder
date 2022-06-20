//
//  PersistenceManager.swift
//  PokeFinder
//
//  Created by River McCaine on 6/17/22.
//

import Foundation

enum PersistenceActionType {
    
    case add, remove
} // END OF ENUM


enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys { static let favorites = "favorites " }
    
    
    static func updateWith(favorite: Pokemon, actionType: PersistenceActionType, completion: @escaping (PokeError?) -> Void) {
        
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.unableToFavorite)
                        return
                    }
                    
                    
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll() { $0.name == favorite.name }
                }
                
                completion(save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    static func retrieveFavorites(completion: @escaping (Result<[Pokemon], PokeError>) -> Void) {
        
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Pokemon].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToComplete))
        }
    }
    
    
    static func save(favorites: [Pokemon]) -> PokeError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            
            return nil
        } catch {
            
            return .unableToFavorite
        }
    }
} // END OF ENUM
