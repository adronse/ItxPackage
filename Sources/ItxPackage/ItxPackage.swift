// Sources/MySwiftPackage/MySwiftPackage.swift

import UIKit

public struct MySwiftPackage {
    public init() {}

    public func sayHello() {
        print("Hello from Itx Package!")
        let alert = UIAlertController(title: "This is a nice alert bro", message: "Alert !!!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        
    }
}
