//
//  File.swift
//
//
//  Created by Alex Paul on 12/21/19.
//

import Foundation

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
                       completion: @escaping (Result<Data, AppError>) -> ()) {
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
      
      // 5. capture data as success case
      completion(.success(data))
    }
    dataTask.resume()
  }  
}
