//
//  ViewController.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/14/21.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModel {
  let header: PostRenderViewModel
  let post: PostRenderViewModel
  let actions: PostRenderViewModel
  let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
  
  private var feedRenderModels = [HomeFeedRenderViewModel]()

  
  private let tableView: UITableView = {
    let tableView = UITableView()
    // Register cells
    tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
    tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
    tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
    tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    createMockModels()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
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
  
  private func createMockModels() {
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
    
    var comments = [PostComment]()
    for x in 0..<4 {
      comments.append(
        PostComment(
          identifier: "123_\(x)",
          username: "Dave",
          text: "So cool bro",
          createdDate: Date(),
          likes: []
        )
      )
    }

    for x in 0..<5 {
      let viewModel = HomeFeedRenderViewModel(
        header: PostRenderViewModel(renderType: .header(provider: user)),
        post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
        actions: PostRenderViewModel(renderType: .actions(provider: "")),
        comments: PostRenderViewModel(renderType: .comments(comments: comments))
      )
      feedRenderModels.append(viewModel)
    }
  }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return feedRenderModels.count * 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let model: HomeFeedRenderViewModel
    if section == 0 {
      model = feedRenderModels[0]
    } else {
      let position = section % 4 == 0 ? section / 4 : ((section - (section % 4)) / 4)
      model = feedRenderModels[position]
    }
    
    let subSection = section % 4
    
    if subSection == 0 {
      // header
      return 1
    } else if subSection == 1 {
      // post
      return 1
    } else if subSection == 2 {
      // actions
      return 1
    } else if subSection == 3 {
      // commments
      let commentsModel = model.comments
      switch commentsModel.renderType {
      case .comments(let comments): return comments.count > 2 ? 2 : comments.count
      case .header, .actions, .primaryContent: return 0
      }
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model: HomeFeedRenderViewModel
    if indexPath.section == 0 {
      model = feedRenderModels[0]
    } else {
      let position = indexPath.section % 4 == 0 ? indexPath.section / 4 : ((indexPath.section - (indexPath.section % 4)) / 4)
      model = feedRenderModels[position]
    }
    
    let subSection = indexPath.section % 4
    
    if subSection == 0 {
      // header
      let headerModel = model.header
      switch headerModel.renderType {
      case .header(let user):
        let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
        return cell
      case .comments, .actions, .primaryContent: return UITableViewCell()
      }
    } else if subSection == 1 {
      // post
      let postModel = model.post
      switch postModel.renderType {
      case .primaryContent(let post):
          let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
          return cell
      case .comments, .actions, .header: return UITableViewCell()
      }
      
    } else if subSection == 2 {
      // actions
      let actionModel = model.actions
      switch actionModel.renderType {
      case .actions(let actions):
          let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
          return cell
      case .comments, .header, .primaryContent: return UITableViewCell()
      }
    } else if subSection == 3 {
      // commments
      let commentModel = model.comments
      switch commentModel.renderType {
      case .comments(let comments):
          let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
          return cell
      case .header, .actions, .primaryContent: return UITableViewCell()
      }
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let subSection = indexPath.section % 4
    if subSection == 0 {
      // header
      return 70
    } else if subSection == 1 {
      // post
      return tableView.width
    } else if subSection == 2 {
      // actions
      return 60
    } else if subSection == 3 {
      // comments row
      return 50
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    let subSection = section % 4
    return subSection == 3 ? 70 : 0
  }
}
