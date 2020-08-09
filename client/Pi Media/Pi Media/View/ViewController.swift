//
//  ViewController.swift
//  Pi Media
//
//  Created by Chris on 04/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StoryboardInstantiatable {
  
  // MARK: - @IBOutlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Initialisers
  static var storyboardName = "Main"
  private var viewModel = ViewModel(service: DataService())
  private let refreshControl = UIRefreshControl()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupTableView()
    self.refreshDataSource()
  }

  // MARK: - Private
  private func setupTableView() {
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.register(FileCell.nib, forCellReuseIdentifier: FileCell.identifier)
    self.refreshControl.addTarget(self, action: #selector(refreshDataSource), for: .valueChanged)
    self.tableView.refreshControl = refreshControl
  }
  
  @objc private func refreshDataSource() {
    self.viewModel.fetchFiles { (files) in
      guard let files = files else {
        self.errorAlert(nil)
        return
      }
      print("files", files)
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
    }
  }
  
  private func errorAlert(_ message: String?) {
    let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alertVC.addAction(.init(title: "Dismiss", style: .default, handler: { (_) in
      alertVC.dismiss(animated: true)
    }))
    present(alertVC, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.files?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: FileCell.identifier, for: indexPath) as? FileCell else { return UITableViewCell() }
    cell.accessoryType = .disclosureIndicator
    cell.viewModel = viewModel.files?[indexPath.row]
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: true)
    
    let cell = self.tableView.cellForRow(at: indexPath) as? FileCell
    let vc = ViewDetailController.instantiate()
    vc.fileModel = cell?.viewModel
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
