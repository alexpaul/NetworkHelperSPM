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
  
  private func verifyCacheDate(for lastModifiedTimeInterval: TimeInterval,
                               maxCacheDays: Int) {
    // create two Date objects from TimeIntervals
    let lastModifiedDate = Date(timeIntervalSince1970: lastModifiedTimeInterval)
    let todaysDate = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
    
    // get an an instance of the user's current calendar
    let calendar = Calendar.current
    
    // get the difference between two Date objects
    // here we are only interested in the difference in days
    let components = calendar.dateComponents([.day], from: lastModifiedDate, to: todaysDate)
    
    // extract the day value from the DateComponent
    let differenceInDates = components.day ?? 0
    
    // clear the urlCache if the maxCacheDays has expired
    if differenceInDates >= maxCacheDays {
      urlSession.configuration.urlCache?.removeAllCachedResponses()
    }
  }
  
  /**
   Perform the Network request for a givne URLRequest.

   - Parameters:
      - request: The URLRequest to perform.
      - maxCacheDays: An optional Int value to indicate maximum number of days to keep using the cached response.
      - completion: The Result will contain a Data object in the case of a successful request or an AppError in the case of a failure.
  */
  public func performDataTask(with request: URLRequest,
                              maxCacheDays: Int = 0,
                              completion: @escaping (Result<Data, AppError>) -> ()) {
    // check if cache should be cleared base on x days since last modified date of saved cache
    // retrieve cache date
    if let lastModifiedTimeInterval = UserDefaults.standard.object(forKey: CacheKey.lastModifiedDate) as? TimeInterval {
      // if expired, clear cache (e.g max cache days is 3, difference in toay and lastModifiedDate is > 3 days
      verifyCacheDate(for: lastModifiedTimeInterval, maxCacheDays: maxCacheDays)
    }
    
    if let cachedResponse = urlSession.configuration.urlCache?.cachedResponse(for: request),
      let _ = cachedResponse.response as? HTTPURLResponse {
      let data = cachedResponse.data
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
