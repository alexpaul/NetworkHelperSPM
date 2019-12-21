//
//  File.swift
//  
//
//  Created by Alex Paul on 12/21/19.
//

import Foundation

public enum AppError: Error, CustomStringConvertible {
  case badURL(String) // associated value
  case noResponse
  case networkClientError(Error) // no internet connection
  case noData
  case decodingError(Error)
  case encodingError(Error)
  case badStatusCode(Int) // 404, 500
  case badMimeType(String) // image/jpg
  
  public var description: String {
    switch self {
    case .decodingError(let error):
      return "\(error)"
    case .badStatusCode(let code):
      return "Bad status code of \(code) returned from web api"
    case .encodingError(let error):
      return "encoding error: \(error)"
    case .networkClientError(let error):
      return "network error: \(error)"
    case .badURL(let url):
      return "\(url) is a bad url"
    case .noData:
      return "no data returned from web api"
    case .noResponse:
      return "no response returned from web api"
    case .badMimeType(let mimeType):
      return "Verify your mime type found a \(mimeType) mime type"
    }
  }
}
