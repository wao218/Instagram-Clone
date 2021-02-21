//
//  NotificationsViewController.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/14/21.
//

import UIKit

class NotificationsViewController: UIViewController {
  
  // MARK: - UI Elements
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.isHidden = false
    tableView.register(NotificiationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificiationLikeEventTableViewCell.identifier)
    tableView.register(NotificiationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificiationFollowEventTableViewCell.identifier)
    return tableView
  }()
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.hidesWhenStopped = true
    spinner.tintColor = .label
    return spinner
  }()
  
  private lazy var noNotificationsView = NoNotificationsView()

  // MARK: - UI Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Notifications"
    view.backgroundColor = .systemBackground
    view.addSubview(spinner)
//    spinner.startAnimating()
    view.addSubview(tableView)
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
    spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    spinner.center = view.center
  }
  
  private func addNoNotificationsView() {
    tableView.isHidden = true
    view.addSubview(noNotificationsView)
    noNotificationsView.frame = CGRect(
      x: 0,
      y: 0,
      width: view.width / 2,
      height: view.width / 4
    )
    noNotificationsView.center = view.center

  }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: NotificiationLikeEventTableViewCell.identifier, for: indexPath) as! NotificiationLikeEventTableViewCell
    return cell
  }
  
  
}
