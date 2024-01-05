//
//  File.swift
//  
//
//  Created by Adrien Ronse on 05/01/2024.
//

import Foundation
import UIKit


public class DeviceInfo {
    static func getDeviceInfo() -> DeviceInfoRequest {
        let device = UIDevice.current
        return DeviceInfoRequest(
            DeviceName: device.name,
            SystemVersion: device.systemVersion,
            AppConsumerVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            DeviceType: device.localizedModel,
            DeviceModel: device.model,
            Locale: Locale.current.identifier,
            ScreenSize: "\(UIScreen.main.bounds.size.width)x\(UIScreen.main.bounds.size.height)"
        )
    }
}
