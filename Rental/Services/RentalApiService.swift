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

    func uploadPhoto(_ params: UploadPhotoParams, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        provider.request(.uploadPhoto(recId: params.recId, base64Data: params.base64Data, fileName: params.fileName)) { result in
            switch result {
            case let .success(response):
                do {
                    try response.filterSuccessfulStatusCodes()
                    onSuccess()
                } catch {
                    onError(error)
                }
                break
            case let .failure(error):
                onError(error)
                break
            }
        }
    }
}