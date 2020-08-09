//
//  DataService.swift
//  Pi Media
//
//  Created by Chris on 04/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import Foundation
import Alamofire

protocol DataServiceProtocol {
  func fetchFileList(_ completion: @escaping ([FileModel]?) -> Void)
  func requestDownload(name: String, completion: @escaping (Bool) -> Void)
  func requestDelete(name: String, completion: @escaping (Bool) -> Void)
  func requestCancel(name: String, completion: @escaping (Bool) -> Void)
}

struct DataService: DataServiceProtocol {
  // MARK: - Singleton
  static let shared = DataService()
  
  let headers = [
      "Content-Type": "application/x-www-form-urlencoded"
  ]
  
  // MARK: - Services
  func fetchFileList(_ completion: @escaping ([FileModel]?) -> Void) {
    guard let url = try? DataRequest.asURLRequest(.list)() else {
      completion(nil)
      return
    }
    
    AF.request(url).responseJSON { (response) in
      if response.error != nil {
        completion(nil)
        return
      }
      guard let data = response.data else {
        completion(nil)
        return
      }
      let fileModels = try! JSONDecoder().decode([FileModel].self, from: data)
      completion(fileModels)
    }
  }
    
  
  func requestDownload(name: String, completion: @escaping (Bool) -> Void) {
    guard let url = try? DataRequest.asURLRequest(.download(name))() else {
      completion(false)
      return
    }
    
    AF.request(url).response { (response) in
      if response.error != nil {
        completion(false)
        return
      }
      completion(true)
    }
  }
  
  func requestDelete(name: String, completion: @escaping (Bool) -> Void) {
    guard let url = try? DataRequest.asURLRequest(.delete(name))() else {
      completion(false)
      return
    }
    
    AF.request(url).response { (response) in
      if response.error != nil {
        completion(false)
        return
      }
      completion(true)
    }
  }
  
  func requestPlay(name: String, completion: @escaping (Bool) -> Void) {
    guard let url = try? DataRequest.asURLRequest(.play(name))() else {
      completion(false)
      return
    }
    
    AF.request(url).response { (response) in
      if response.error != nil {
        completion(false)
        return
      }
      completion(true)
    }
  }
  
  func requestCancel(name: String, completion: @escaping (Bool) -> Void) {
    guard let url = try? DataRequest.asURLRequest(.cancel(name))() else {
      completion(false)
      return
    }
    
    AF.request(url).response { (response) in
      if response.error != nil {
        completion(false)
        return
      }
      completion(true)
    }
  }
}
