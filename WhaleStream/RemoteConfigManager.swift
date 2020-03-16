//
//  RemoteConfigManager.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/26/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import Firebase

struct RemoteConfigManager {
    private static var remoteConfig: RemoteConfig = {
        var remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings(developerModeEnabled: true)
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        return remoteConfig
    }()
    
    
    
    
    static func configure(expirationDuration: TimeInterval = 0) {
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            print("recieved values from remote config")
            RemoteConfig.remoteConfig().activate(completionHandler: nil)
        }
    }
    
    static func value(forKey key: String) -> String {
        return remoteConfig.configValue(forKey: key).stringValue!
    }
    
}
