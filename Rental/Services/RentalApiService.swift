//
// Created by Attila AMBRUS on 2019-03-14.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import Moya

class RentalApiService: BaseApi, RentalApi {

    var provider = MoyaProvider<RentalApiEndPoints>()

    func getReplaceAttachmentList(eqId: String, emrId: String) -> Single<[AttachmentModel]> {
        return self.provider.rx.send(.replaceAttachmentList(eqId: eqId, emrId: emrId))
    }

    func uploadPhoto(_ params: UploadPhotoParams) -> Completable {
        return self.provider.rx.execute(.uploadPhoto(recId: params.recId, base64Data: params.base64Data, fileName: params.fileName))
    }

    func partialPostEMR(_ lineIds: String) -> Completable {
        return self.provider.rx.execute(.partialPostEMR(lineIds: lineIds))
    }
}