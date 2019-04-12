//
// Created by Attila AMBRUS on 2019-04-10.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Sync
import EVReflection
import MicrosoftAzureMobile_Xapt

class RenEMRLineInsertHandler: PostHandler {
    override var priority: Int {
        return 1000
    }

    override func onBeforeRequest(requestArgs: BaseRequestHandlerArgs) {
        super.onBeforeRequest(requestArgs: requestArgs)

        if let data = requestArgs.request.httpBody {
            var ignoredProperties = (requestArgs.entityType as! MOB_RenEMRLine.Type).init().ignoredJSONProperties
            var rDict: [String: Any] = [:]

            for (key, value) in try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                if !ignoredProperties.contains(key as! String) {
                    rDict[key as! String] = value
                }
            }

            requestArgs.request.httpBody = try! JSONSerialization.data(withJSONObject: rDict)
        }
    }
}
