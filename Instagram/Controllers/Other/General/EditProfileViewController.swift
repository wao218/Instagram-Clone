//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Wesley Osborne on 2/14/21.
//

import UIKit

struct EditProfileFormModel {
  let label: String
  let placeholder: String
  var value: String?
}

final class EditProfileViewController: UIViewController {
  
  // MARK: - UI Elements
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
    return tableView
  }()
  
  // MARK: - Data Model
  private var models = [[EditProfileFormModel]]()
  
  // MARK: - UI Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureModels()
    view.backgroundColor = .systemBackground
    
    tableView.tableHeaderView = createTableHeaderView()
    
    tableView.dataSource = self
    
    view.addSubview(tableView)
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
  private func createTableHeaderView() -> UIView {
    let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 4).integral)
    let size = header.height / 1.5
    let profilePhotoButton = UIButton(frame: CGRect(x: (view.width - size) / 2, y: (header.height - size) / 2, width: size, height: size))
    
    header.addSubview(profilePhotoButton)
    profilePhotoButton.layer.masksToBounds = true
    profilePhotoButton.layer.cornerRadius = size / 2.0
    profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
    profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
    profilePhotoButton.tintColor = .label
    profilePhotoButton.layer.borderWidth = 1
    profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
    return header
  }
  
  private func configureModels() {
    // name, username, website, bio
    let section1Labels = ["Name", "Username", "Bio"]
    var section1 = [EditProfileFormModel]()
    for label in section1Labels {
      let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
      section1.append(model)
    }
    models.append(section1)
    
    // email, phone, gender
    let section2Labels = ["Email", "Phone", "Gender"]
    var section2 = [EditProfileFormModel]()
    for label in section2Labels {
      let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
      section2.append(model)
    }
    models.append(section2)
  }
  
  // MARK: - Action Functions
  
  @objc private func didTapSave() {
    // Save info to database
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func didTapCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func didTapProfilePicture() {
    let actionSheet = UIAlertController(title: "Profile Picture", message: "Change profile picture", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
      
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (_) in
      
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    actionSheet.popoverPresentationController?.sourceView = view
    actionSheet.popoverPresentationController?.sourceRect = view.bounds
    
    present(actionSheet, animated: true)
  }

  @objc private func didTapProfilePhotoButton() {
    
  }
  
}

// MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return models.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.section][indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
    cell.configure(with: model)
    cell.delegate = self
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section == 1 else {
      return nil
    }
    return "Private Information"
  }
  
}

extension EditProfileViewController: FormTableViewCellDelegate {
  
  func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
    // Update the model
    print(updatedModel.value ?? "nil")
  }
  
  
}
