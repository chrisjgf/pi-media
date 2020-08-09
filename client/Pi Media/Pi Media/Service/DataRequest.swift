//
//  DataRequest.swift
//  Pi Media
//
//  Created by Chris on 04/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import UIKit
import Alamofire

public enum DataRequest: URLRequestConvertible {
  enum Constants {
//    static let baseURLPath = "http://localhost:3000"
    static let baseURLPath = "http://raspberrypi.local:3000"
  }

  case delete(String)
  case download(String)
  case play(String)
  case list
  case cancel(String)
  
  var method: HTTPMethod {
    switch self {
    case .list:
      return .get
    default:
      return .post
    }
  }
    
  var path: String {
    switch self {
    case .delete:
      return "/files/delete"
    case .download:
      return "/files/download"
    case .list:
      return "/files/list"
    case .play:
      return "/files/play"
    case .cancel:
      return "/files/cancel"
    }
  }
  
  var parameters: [String: Any] {
    var params: [String: Any] = [:]
    switch self {
    case .download(let filename),
         .cancel(let filename),
         .play(let filename),
         .delete(let filename):
      params["filename"] = filename
    default:
      break
    }
    return params
  }
  
  public func asURLRequest() throws -> URLRequest {
    let url = try Constants.baseURLPath.asURL()
    
    var request = URLRequest(url: url.appendingPathComponent(path))
    request.httpMethod = method.rawValue
    request.timeoutInterval = TimeInterval(10 * 1000)
    return try URLEncoding.default.encode(request, with: parameters)
  }
  
}
