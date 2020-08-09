//
//  FileCell.swift
//  Pi Media
//
//  Created by Chris on 04/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {
  // MARK: - Static
  static let identifier = "FileCell"
  static let nib = UINib(nibName: FileCell.identifier, bundle: nil)

  // MARK: - @IBOutlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!

  // MARK: - Intialisers
  var viewModel: FileModel? {
    didSet {
      self.titleLabel.text = viewModel?.name ?? ""
      self.statusLabel.text = formattedStatus()
    }
  }
  
  private func formattedStatus() -> String? {
    switch viewModel?.status {
    case "PROGRESS":
      return "[...]"
    case "COMPLETE":
      return "[✓]"
    default:
      return nil
    }
  }
}
