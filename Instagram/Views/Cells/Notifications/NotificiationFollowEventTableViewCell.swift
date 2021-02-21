//
//  NotificiationFollowEventTableViewCell.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/20/21.
//

import UIKit

protocol NotificiationFollowEventTableViewCellDelegate: AnyObject {
  func didTapFollowUnFollowButton(model: UserNotification)
}

class NotificiationFollowEventTableViewCell: UITableViewCell {
  static let identifier = "NotificiationFollowEventTableViewCell"
  
  weak var delegate: NotificiationFollowEventTableViewCellDelegate?
  
  private var model: UserNotification?
  
  // MARK: - UI Elements
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .tertiarySystemBackground
    return imageView
  }()
  
  private let label: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 0
    label.text = "KanyeWest started following you."
    return label
  }()
  
  private let followButton: UIButton = {
    let button = UIButton()
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 4
    return button
  }()
  
  // MARK: - UI Functions
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(profileImageView)
    contentView.addSubview(label)
    contentView.addSubview(followButton)
    followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    configureForFollow()
    selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    followButton.setTitle(nil, for: .normal)
    followButton.backgroundColor = nil
    followButton.layer.borderWidth = 0
    label.text = nil
    profileImageView.image = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    profileImageView.frame = CGRect(
      x: 3,
      y: 3,
      width: contentView.height - 6,
      height: contentView.height - 6
    )
    profileImageView.layer.cornerRadius = profileImageView.height / 2
    
    let size: CGFloat = 100
    let buttonHeight: CGFloat = 40
    followButton.frame = CGRect(
      x: contentView.width - 5 - size,
      y: (contentView.height - buttonHeight) / 2,
      width: size,
      height: buttonHeight
    )
   
    label.frame = CGRect(
      x: profileImageView.right + 5,
      y: 0,
      width: contentView.width - size - profileImageView.width - 16,
      height: contentView.height
    )
  }
  
  public func configure(with model: UserNotification) {
    self.model = model
    switch model.type {
    case .like(_):
      break
    case .follow(let state):
      // configure button
      switch state {
      case .following:
        // show unfollow button
        configureForFollow()
      case .not_following:
        // show follow button
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = .link
      }
      break
    }
    
    label.text = model.text
    profileImageView.sd_setImage(with: model.user.profilePhoto, completed: nil)
  }
  
  private func configureForFollow() {
    followButton.setTitle("Unfollow", for: .normal)
    followButton.setTitleColor(.label, for: .normal)
    followButton.layer.borderWidth = 1
    followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
    followButton.backgroundColor = .link
  }
  
  @objc private func didTapFollowButton() {
    guard let model = model else {
      return
    }
    
    delegate?.didTapFollowUnFollowButton(model: model)
  }
}
