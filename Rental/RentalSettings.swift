//
// Created by Papp Imre on 2019-02-28.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base

class RentalSettings: BaseSettings {
    override var apiUrl: String {
        //return "https://mobile-demo.xapt.com/env/test/069/nmdef/rental"
        return "https://mobile-demo.xapt.com/env/dev/0457/nmdef/rental"
        //return "https://mobile-demo.xapt.com/env/dev/0442/nmdef/rental"
    }
}