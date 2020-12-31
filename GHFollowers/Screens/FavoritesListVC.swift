//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 12/3/20.
//

import UIKit

class FavoritesListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        
        PersistanceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                break
            }
        }
    }

}
