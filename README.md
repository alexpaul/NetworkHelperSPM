# NetworkHelper

This Swift package is a URLSession wrapper class that enables making network requests (examples of supported HTTP methods are GET, POST, DELETE, etc). 


[Version Releases](https://github.com/alexpaul/NetworkHelperSPM/releases)

## Requirements 

* Xcode 10.2+ 
* Swift 5.0+ 

## Installation 

Currently NetworkHelperSPM only has support for Swift package manager. To install copy this github url ```https://github.com/alexpaul/NetworkHelperSPM``` and navigate to Xcode. Once in Xcode select File -> Swift Packages -> Add Package Dependency and paste the copied url into the search field in the presented dialog. In the Choose Package Options select the Version Rules option which should be the presented default choice and click Next then Finish. At this point the package should have been installed successfully. 

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
