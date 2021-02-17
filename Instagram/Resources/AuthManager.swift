//
//  AuthManager.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/15/21.
//

import Foundation
import FirebaseAuth

public class AuthManager {
  
  static let shared = AuthManager()
  
  // MARK: - Public

  public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
    /*
     - Check if username is available
     - Check if email is available
     */
    DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
      if canCreate {
        /*
         - Create account
         - Insert account into database
         */
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
          guard error == nil, result != nil else {
            // Firebase auth could not create account
            completion(false)
            return
          }
          
          // Insert into database
          DatabaseManager.shared.insertNewUser(with: email, username: username) { (inserted) in
            if inserted {
              completion(true)
              return
            } else {
              // Failed to insert ot database
              completion(false)
              return
            }
          }
        }
      } else {
        // either username or email exists
        completion(false)
      }
    }
  }
  
  public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
    if let email = email {
      // email log in
      Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
        guard authResult != nil, error == nil else {
          completion(false)
          return
        }
        
        completion(true)
      }
    } else if let username = username {
      // username log in
      print(username)
    }
  }
  
  /// Attempt to log out Firebase user
  public func signOut(completion: (Bool) -> Void) {
    do {
      try Auth.auth().signOut()
      completion(true)
      return
    } catch {
      print(error)
      completion(false)
      return
    }
  }
}
