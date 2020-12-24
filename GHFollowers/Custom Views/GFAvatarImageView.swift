//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 12/20/20.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "avatar-placeholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = 10
        // Have to do this otherwise the underlying UIImage would still show
        // with sharp corners even though the UIImageView has rounded corner radius
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
    
        // First check if the image is in cache before downloading the image
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
    
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            
            // Once we have retrieved the image, we add it to the cache
            self.cache.setObject(image, forKey: cacheKey)
            
            // Set the image on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
    
}
