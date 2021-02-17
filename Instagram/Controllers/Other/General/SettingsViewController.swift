//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/14/21.
//

import UIKit

struct SettingCellModel {
  let title: String
  let handler: (() -> Void)
}

/// View Controller to show user settings
final class SettingsViewController: UIViewController {
  
  // MARK: - UI Elements
  private let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return tableView
  }()
  
  // MARK: - Data Model
  private var data = [[SettingCellModel]]()
  
  // MARK: - UI Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureModels()

    view.backgroundColor = .systemBackground
    view.addSubview(tableView)

    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
  
  private func configureModels() {
    let section = [
      SettingCellModel(title: "Log Out") { [weak self] in
        self?.didTapLogOut()
      }
    ]
    data.append(section)
  }
  
  // MARK: - Action Functions
  private func didTapLogOut() {
    
    let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
      AuthManager.shared.signOut { (success) in
        DispatchQueue.main.async {
          if success {
            // present log in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true) {
              self.navigationController?.popToRootViewController(animated: false)
              self.tabBarController?.selectedIndex = 0
            }
          } else {
            // error occurred
            fatalError("Could not log out user")
          }

        }
      }
    }))

    actionSheet.popoverPresentationController?.sourceView = tableView
    actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
    
    present(actionSheet, animated: true)
  }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = data[indexPath.section][indexPath.row].title
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Handle cell selection
    let model = data[indexPath.section][indexPath.row]
    model.handler()
  }
  
  
  
  
}
