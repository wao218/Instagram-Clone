//
//  NotificiationLikeEventTableViewCell.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/20/21.
//

import UIKit

protocol NotificiationLikeEventTableViewCellDelegate: AnyObject {
  func didTapRelatedPostButton(model: String)
}

class NotificiationLikeEventTableViewCell: UITableViewCell {
  static let identifier = "NotificiationLikeEventTableViewCell"
  
  weak var delegate: NotificiationLikeEventTableViewCellDelegate?
  
  // MARK: - UI Elements
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let label: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 0
    return label
  }()
  
  private let postButton: UIButton = {
    let button = UIButton()
    return button
  }()
  
  // MARK: - UI Functions
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(profileImageView)
    contentView.addSubview(label)
    contentView.addSubview(postButton)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    postButton.setBackgroundImage(nil, for: .normal)
    label.text = nil
    profileImageView.image = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  
  public func configure(with model: String) {
    
  }
}
