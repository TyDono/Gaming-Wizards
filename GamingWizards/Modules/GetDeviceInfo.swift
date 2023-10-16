//
//  GetDeviceInfo.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/16/23.
//

import Foundation
import UIKit

class DeviceInfo {
    
    static func getDeviceInfo() -> String {
        let deviceName = UIDevice.current.name
        let deviceModel = UIDevice.current.model
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion

        let deviceInfoString = """
            Device Name: \(deviceName)
            Device Model: \(deviceModel)
            System Name: \(systemName)
            System Version: \(systemVersion)
        """

        return deviceInfoString
    }
    
}
