//
// Created by Attila AMBRUS on 2019-03-14.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import Moya

class ReplaceAttachmentService: ReplaceAttachment {
    var provider = MoyaProvider<ReplaceAttachmentEndPoint>()

    func getAttachments(eqId: String, emrId: String) -> Single<[AttachmentModel]> {
//        return Observable<[AttachmentModel]>.create { observer in
//            let disposable = self.provider.rx.request(.list(eqId: eqId, emrId: emrId)).subscribe(onSuccess: { response in
//                do {
//                    observer.onNext(try response.data.parse([AttachmentModel].self))
//                    observer.onCompleted()
//                } catch {
//                    observer.onError(error)
//                }
//            }, onError: { error in
//                observer.onError(error)
//            })
//            return disposable
//        }

        return self.provider.rx.send(.list(eqId: eqId, emrId: emrId))
    }
}