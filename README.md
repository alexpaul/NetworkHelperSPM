# NetworkHelper

This Swift package is a URLSession wrapper class that enables making GET, POST, DELETE... and related HTTP network requests. NetworkHelper's ```performDataTask``` method also takes an optional maximum number of days parameter. This will enable your app to restrict fetching network resources. 


[Version Releases](https://github.com/alexpaul/NetworkHelperSPM/releases)

## Requirements 

* Xcode 10.2+ 
* Swift 5.0+ 

## Swift Package Installation 

To install copy this github url
```https://github.com/alexpaul/NetworkHelperSPM```  
Navigate to Xcode and do the following: 
 - select **File -> Swift Packages -> Add Package Dependency** 
 - paste the copied url above into the search field in the presented dialog
 - In the **Choose Package Options** select the Version Rules option (default option). Version rules will update Swift packages based on their relesase versions e.g 1.0.1
 
 Click Next then Finish. 
 At this point the package should have been installed successfully 🥳 

## Swift Package Dependencies 

* None

## Usage 

```swift
import NetworkHelper

struct APIClient {
  static func fetchData() {
    let urlString = "https://api.webapi.com/endpoint"
    guard let url = URL(string: urlString) else {
      // bad url 
      return 
    }
    let request = URLRequest(url: url) 
    NetworkHelper.shared.performDataTask(with: request) { result in 
      switch result {
        case .failure(let appError): 
          // handle error
        case .success(let data): 
          // use data to create Swift model or UIImage or other object as needed
      }
    }
  }
}
```

## Error states 

<pre>
case badURL
  A bad formatted URL was provided.
  
case noResponse
  There wasn't any response returned from the server.
  
case networkClientError
  A network client error e.g no internet connection. 
  
case noData

case decodingError
  The Swift model isn't correctly formatted as per the JSON. 
  
case encodingError

case badStatusCode
  A status code other that 200 - 299 was returned from the server. 
  
case badMimeType
  In the case of an image, a wrongly formatted mime type was found. 
</pre>

## Caching 

NetworkHelperSPM caches the network response for a day as the default. This value can be overridden to be 0 or a value that is sufficient to your needs. 

#### Caching example 

```swift 
NetworkHelper.shared.performDataTask(with: request,
                                     maxCacheDays: 3) { (result) in
  // code here
}
```

## License

NetworkHelper is released under the MIT license. See [LICENSE](https://github.com/alexpaul/NetworkHelperSPM/blob/master/LICENSE) for details.

