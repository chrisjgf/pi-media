//
//  ViewModel.swift
//  Pi Media
//
//  Created by Chris on 04/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import Foundation

protocol ViewModelProtocol: class {
  func fetchFiles(_ completion: @escaping ([FileModel]?) -> Void)
}

class ViewModel: ViewModelProtocol {
  
  private var service: DataService
  var files: [FileModel]?
  
  init(service: DataService) {
    self.service = service
  }
  
  // MARK: - Public
  func fetchFiles(_ completion: @escaping ([FileModel]?) -> Void) {
    self.service.fetchFileList { (files) in
      self.files = files
      completion(files)
    }
  }
}
