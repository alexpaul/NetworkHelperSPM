# NetworkHelper

This Swift package is a URLSession wrapper class that enables making network requests (examples of supported HTTP methods are GET, POST, DELETE, etc). 


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

## Licence 

NetworkHelper is released under the MIT license. See [LICENSE]() for details.

