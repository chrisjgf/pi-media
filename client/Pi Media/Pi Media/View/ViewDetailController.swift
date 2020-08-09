//
//  ViewDetailController.swift
//  Pi Media
//
//  Created by Chris on 05/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import UIKit

class ViewDetailController: UIViewController, StoryboardInstantiatable {
  
  // MARK: - @IBOutlets
  @IBOutlet weak var downloadButton: LoadingButton!
  @IBOutlet weak var deleteButton: LoadingButton!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var cancelButton: LoadingButton!
  
  // MARK: - @IBActions
  @IBAction func downloadButtonPress() {
    guard let name = fileModel?.name else { return }
    self.downloadButton.showLoading()
    self.viewModel?.downloadFile(name, completion: { (success) in
      self.downloadButton.hideLoading()
    })
  }
  
  @IBAction func deleteButtonPress() {
    guard let name = fileModel?.name else { return }
    self.deleteButton.showLoading()
    self.viewModel?.deleteFile(name, completion: { (success) in
      self.deleteButton.hideLoading()
    })
  }
  
  @IBAction func playButtonPress() {
    guard let name = fileModel?.name else { return }
    self.viewModel?.playFile(name)
  }
  
  @IBAction func cancelPress() {
    guard let name = fileModel?.name else { return }
    self.cancelButton.showLoading()
    self.viewModel?.cancelDownload(name, completion: { (success) in
      self.viewModel?.deleteFile(name, completion: { (success) in
        self.cancelButton.hideLoading()
      })
    })
  }
  
  // MARK: - Initialisers
  static var storyboardName = "Main"
  var viewModel: ViewDetailModel?
  var fileModel: FileModel? {
    didSet {
      self.viewModel = ViewDetailModel(service: DataService())
      self.navigationItem.title = self.fileModel?.name ?? ""
    }
  }
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  // MARK: - Private
  private func setupUI() {
    self.downloadButton.applyCornerRadius(12.0)
    self.deleteButton.applyCornerRadius(12.0)
    self.playButton.applyCornerRadius(12.0)
    self.cancelButton.applyCornerRadius(12.0)
  }
}
