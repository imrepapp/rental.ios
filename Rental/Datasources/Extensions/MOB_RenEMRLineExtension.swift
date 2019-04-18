//
// Created by Attila AMBRUS on 2019-04-11.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Sync

public extension IgnoredJSON where Self: MOB_RenEMRLine {
    var ignoredJSONProperties: [String] {
        return [
            "isScanned",
            "isShipped",
            "isReceived",
            "isChecked"
        ]
    }
}
