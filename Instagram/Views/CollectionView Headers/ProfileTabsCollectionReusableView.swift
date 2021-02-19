//
//  ProfileTabsCollectionReusableView.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/18/21.
//

import UIKit

class ProfileTabsCollectionReusableView: UICollectionReusableView {
  static let identifier = "ProfileTabsCollectionReusableView"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .orange
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
