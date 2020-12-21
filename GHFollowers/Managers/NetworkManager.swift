//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 12/20/20.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com"
    
    private init () {
    
    }
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void ) {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This username creates an invalid request. Please try again")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            if let _ = error {
                completed(nil, "Unable to handle your request. Please check your internet connection")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response type from the server. Please try again")
                return
            }
            
            guard let data = data else {
                completed(nil, "The data received from the server was invalid")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "The data received from the server was invalid")
            }
        
        }
        
        task.resume()
    }
}
