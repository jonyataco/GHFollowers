//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 12/25/20.
//

import UIKit

class UserInfoVC: UIViewController {

    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }


    func configureNavigationBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

}
