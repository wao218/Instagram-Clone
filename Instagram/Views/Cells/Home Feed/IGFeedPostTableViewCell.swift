//
//  IGFeedPostTableViewCell.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/17/21.
//

import UIKit

final class IGFeedPostTableViewCell: UITableViewCell {
  
  static let identifier = "IGFeedPostTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure() {
    // configure the cell
  }
}
