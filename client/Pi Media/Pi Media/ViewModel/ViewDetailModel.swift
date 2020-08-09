//
//  ViewDetailModel.swift
//  Pi Media
//
//  Created by Chris on 05/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import Foundation

protocol ViewDetailModelProtcol: class {
  func downloadFile(_ name: String, completion: @escaping (Bool) -> Void)
  func deleteFile(_ name: String, completion: @escaping (Bool) -> Void)
  func playFile(_ name: String)
  func cancelDownload(_ name: String, completion: @escaping (Bool) -> Void)
}

class ViewDetailModel: ViewDetailModelProtcol {
  
  private var service: DataService
  
  // MARK: - Init
  init(service: DataService) {
    self.service = service
  }
  
  // MARK: - Public
  func downloadFile(_ name: String, completion: @escaping (Bool) -> Void) {
    self.service.requestDownload(name: name) { (success) in
      completion(success)
    }
  }
  
  func deleteFile(_ name: String, completion: @escaping (Bool) -> Void) {
    self.service.requestDelete(name: name) { (success) in
      completion(success)
    }
  }
  
  func playFile(_ name: String) {
    self.service.requestPlay(name: name) { (success) in
      print("success", success)
    }
  }
  
  func cancelDownload(_ name: String, completion: @escaping (Bool) -> Void) {
    self.service.requestCancel(name: name) { (success) in
      completion(success)
    }
  }
  
}
