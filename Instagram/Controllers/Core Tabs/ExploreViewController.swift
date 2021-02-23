//
//  ExploreViewController.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/14/21.
//

import UIKit

class ExploreViewController: UIViewController {
  
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Search..."
    searchBar.backgroundColor = .secondarySystemBackground
    return searchBar
  }()
  
  private let dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.isHidden = true
    view.alpha = 0
    return view
  }()
  
  private var collectionView: UICollectionView?
  
  private var tabbedSearchCollectionView: UICollectionView?
  
  private var models = [UserPost]()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    configureSearchBar()
    configureExploreCollection()
    configureDimmedView()
    configureTabbedSearch()
  }

  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView?.frame = view.bounds
    dimmedView.frame = view.bounds
    tabbedSearchCollectionView?.frame = CGRect(
      x: 0,
      y: view.safeAreaInsets.top,
      width: view.width,
      height: 72
    )
  }
  
  private func configureExploreCollection() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let size = (view.width - 4) / 3
    layout.itemSize = CGSize(width: size, height: size)
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    collectionView?.delegate = self
    collectionView?.dataSource = self
    guard let collectionView = collectionView else {
      return
    }
    view.addSubview(collectionView)
  }
  
  private func configureSearchBar() {
    navigationController?.navigationBar.topItem?.titleView = searchBar
    searchBar.delegate = self
  }
  
  private func configureDimmedView() {
    view.addSubview(dimmedView)
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
    gesture.numberOfTouchesRequired = 1
    gesture.numberOfTapsRequired = 1
    dimmedView.addGestureRecognizer(gesture)
  }
  
  private func configureTabbedSearch() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.width / 2, height: 52)
    layout.scrollDirection = .horizontal
    tabbedSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    tabbedSearchCollectionView?.backgroundColor = .yellow
    tabbedSearchCollectionView?.isHidden = true
    guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
      return
    }
    tabbedSearchCollectionView.delegate = self
    tabbedSearchCollectionView.dataSource = self
    view.addSubview(tabbedSearchCollectionView)
  }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == tabbedSearchCollectionView {
      return 0
    }
    return 100
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
      return UICollectionViewCell()
    }
    
//    cell.configure(with: <#T##UserPost#>)
    cell.configure(debug: "test")
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    if collectionView == tabbedSearchCollectionView {
      // change search context
      return
    }
//    let model = models[indexPath.row]
    
    let user = User(
      username: "Joe",
      bio: "",
      name: (first: "", last: ""),
      profilePhoto: URL(string: "https://www.google.com")!,
      birthDate: Date(),
      gender: .male,
      counts: UserCount(followers: 100, following: 100, posts: 100),
      joinDate: Date()
    )
    let post = UserPost(
      identifier: "",
      postType: .photo,
      thumbnailImage: URL(string: "https://www.google.com")!,
      postURL: URL(string: "https://www.google.com")!,
      caption: nil,
      likeCount: [],
      comments: [],
      createdDate: Date(),
      taggedUsers: [],
      owner: user
    )
    let vc = PostViewController(model: post)
    vc.title = post.postType.rawValue
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension ExploreViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    navigationItem.rightBarButtonItem = nil
    guard let text = searchBar.text, !text.isEmpty else {
      return
    }
    
    query(text)
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelSearch))
    
    dimmedView.isHidden = false
    UIView.animate(withDuration: 0.2, animations: {
      self.dimmedView.alpha = 0.4
    }) { (done) in
      if done {
        self.tabbedSearchCollectionView?.isHidden = false
      }
    }
  }
  
  @objc private func didCancelSearch() {
    searchBar.resignFirstResponder()
    navigationItem.rightBarButtonItem = nil
    
    UIView.animate(withDuration: 0.2, animations: {
      self.dimmedView.alpha = 0
    }) { (done) in
      if done {
        self.dimmedView.isHidden = true
        self.tabbedSearchCollectionView?.isHidden = true
      }
    }
  }
  
  private func query(_ text: String) {
    // perform the search in the back end
  }
}
