//
//  File.swift
//
//
//  Created by Adrien Ronse on 09/01/2024.
//

import Foundation

struct CreateMobileIssueInput : Encodable {
    let apiKey: String
    let title: String
    let description: String
    let priority: String
}

struct DeviceInfoInput : Encodable {
    let AppConsumerVersion: String
    let DeviceModel: String
    let DeviceType: String
    let ScreenSize: String
    let DeviceName: String
    let SystemVersion: String
    let Locale: String
}
