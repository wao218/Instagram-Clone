//
//  ViewController.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/14/21.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    handleNotAuthenticated()
  }
  
  private func handleNotAuthenticated() {
    // Check auth status
    if Auth.auth().currentUser == nil {
      // Show log in
      let loginVC = LoginViewController()
      loginVC.modalPresentationStyle = .fullScreen
      present(loginVC, animated: false)
    }
  }

}

