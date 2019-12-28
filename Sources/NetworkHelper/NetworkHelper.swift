//
//  File.swift
//
//
//  Created by Alex Paul on 12/21/19.
//

import Foundation

private struct CacheKey {
  static let lastModifiedDate = "Last Modified Cached Date"
}

public class NetworkHelper {
  // we will create a shared instance of the NetworkHelper
  public static let shared = NetworkHelper()
  
  private var urlSession: URLSession
  
  // we will make the default initializer private
  // required in order to be considered a singleton
  // also forbids anyone from creating an instance of NetworkHelper
  private init() {
    urlSession = URLSession(configuration: .default)
  }
  
  public func performDataTask(with request: URLRequest,
                              maxCacheDays: Int = 1,
                              completion: @escaping (Result<Data, AppError>) -> ()) {
    
    
    // https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy
    switch request.cachePolicy {
    case .useProtocolCachePolicy:
      print("useProtocolCachePolicy")
    default:
      print("other policy")
    }
    
    // clear cache base on given criteria e.g number of days since last fetch
    
    // How to leverage HTTP cache in iOS
    // https://www.fabernovel.com/en/engineering/how-to-leverage-http-cache-in-ios
    
    // NSHipster - NSURLCache
    // https://nshipster.com/nsurlcache/
    
    // Apple - Accessing cached data
    // https://developer.apple.com/documentation/foundation/url_loading_system/accessing_cached_data
    
    
    // TODO: check if cache should be cleared base on x days since last modified date of saved cache
    // retrieve cache date
    if let lastModifiedDate = UserDefaults.standard.object(forKey: CacheKey.lastModifiedDate) as? Double {
      //
      print("last modified cache date: \(Date(timeIntervalSince1970: lastModifiedDate))")
      
  
      // TODO: if expired, clear cache (e.g max cache days is 3, difference in toay and lastModifiedDate is > 3 days
      //urlSession.configuration.urlCache?.removeAllCachedResponses()
    }
    
    
    if let cachedResponse = urlSession.configuration.urlCache?.cachedResponse(for: request),
      let httpURLResponse = cachedResponse.response as? HTTPURLResponse {
     // let userInfo = cachedResponse.userInfo {
      
      let data = cachedResponse.data
        
      print("userInfo \(cachedResponse.userInfo)")
      
      print("httpURLResponse: \(httpURLResponse)")
      
      let currentDate = Date()
      let cacheDateHeader = currentDate.timeIntervalSince1970
      print("cacheDateHeader \(cacheDateHeader)")
      
      completion(.success(data))
      return
    }
    
    // two states on dataTask, resume() and suspended by default
    // suspended simply won't perform network request
    // this ultimately leads to debugging errors and time lost if
    // you don't explicitly resume() request
    
    let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            
      // 1. deal with error if any
      // check for client network errors
      if let error = error {
        completion(.failure(.networkClientError(error)))
        return
      }
      
      // 2. downcast URLResponse (response) to HTTPURLResponse to
      //    get access to the statusCode property on HTTPURLResponse
      guard let urlResponse = response as? HTTPURLResponse else {
        completion(.failure(.noResponse))
        return
      }
      
      // 3. unwrap the data object
      guard let data = data else {
        completion(.failure(.noData))
        return
      }
      
      // 4. validate that the status code is in the 200 range otherwise it's a
      //    bad status code
      switch urlResponse.statusCode {
      case 200...299: break // everything went well here
      default:
        completion(.failure(.badStatusCode(urlResponse.statusCode)))
        return
      }
      
      // TODO: save last modified cache date
      let cachedDate = Date().timeIntervalSince1970
      UserDefaults.standard.set(cachedDate, forKey: CacheKey.lastModifiedDate)
      
      // 5. capture data as success case
      completion(.success(data))
    }
    dataTask.resume()
  }  
}
