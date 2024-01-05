//
//  File.swift
//
//
//  Created by Adrien Ronse on 05/01/2024.
//

import Foundation


struct DeviceInfoRequest: Encodable {
    let DeviceName: String
    let SystemVersion: String
    let AppConsumerVersion: String
    let DeviceType: String
    let DeviceModel: String
    let Locale: String
    let ScreenSize: String
}
