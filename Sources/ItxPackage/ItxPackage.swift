// Sources/MySwiftPackage/MySwiftPackage.swift

import UIKit

public struct MySwiftPackage {
    public init() {}

    public func sayHello() {
        let alert = UIAlertController(title: "Hello from ItxPackage brooo", message: "What a nice package you got here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    }
}
