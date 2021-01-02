//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 12/31/20.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    enum Keys {
        static let favorites = "favorites"
    }

    static private let defaults = UserDefaults.standard
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
            
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        // If the retrieved data is nil, that means that there is no saved data yet. Not necessarily an error
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        // Creating a decoder to decode the data
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        // First we encode the data and once encoded, write it back into user defaults
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
