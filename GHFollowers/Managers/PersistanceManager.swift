//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 12/31/20.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    
    enum Keys {
        static let favorites = "favorites"
    }

    static private let defaults = UserDefaults.standard
    
    
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                // Create a mutable copy of favorites because we need to either add or remove
                var retrievedFavorites = favorites
                
                switch actionType {
                case .add:
                    guard retrievedFavorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    retrievedFavorites.append(favorite)
                case .remove:
                    retrievedFavorites.removeAll { $0.login == favorite.login }
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
