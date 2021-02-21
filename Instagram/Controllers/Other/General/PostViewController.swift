//
//  PostViewController.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/14/21.
//

import UIKit

class PostViewController: UIViewController {
  
  private let model: UserPost?
  
  // MARK: - UI Elements
  private let tableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()
  
  // MARK: - Init
  init(model: UserPost?) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: UI Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.delegate = self
    view.backgroundColor = .systemBackground
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
