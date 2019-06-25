//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa
import RealmSwift

struct AddPhotoParams: Parameters {
    var emrLine: EMRItemViewModel
    var base64Data: String
}

class AddPhotoViewModel: BaseViewModel {
    private var parameters = AddPhotoParams(emrLine: EMRItemViewModel(), base64Data: "")
    var emrLine: EMRItemViewModel {
        return parameters.emrLine
    }

    let cancelCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()
    let photoImage = BehaviorRelay<UIImage>(value: UIImage())

    override func instantiate(with params: Parameters) {
        parameters = params as! AddPhotoParams
        title.val = "Add Photo: \(parameters.emrLine.emrId.val!)"

        if let decodedData = Data(base64Encoded: parameters.base64Data, options: .ignoreUnknownCharacters) {
            photoImage.val = UIImage(data: decodedData)!
        }

        cancelCommand += { _ in
            self.next(step:RentalStep.dismiss)
        } => disposeBag

        saveCommand += { _ in
            self.isLoading.val = true

            _ = AppDelegate.api.uploadPhoto(UploadPhotoParams(
                    recId: self.emrLine.id.val!,
                    base64Data: self.parameters.base64Data,
                    fileName: String(format: "%@.jpg", arguments: [self.parameters.emrLine.id.val!])))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onCompleted: {
                    let realm = try! Realm()
                    try! realm.write {
                        let photoData = MOB_RenEMRLinePhoto()
                        photoData.lineId = self.emrLine.id.val!
                        photoData.photoBase64 = self.parameters.base64Data
                        realm.add(photoData)
                    }

                    self.isLoading.val = false

                    self.send(message: .alert(config: AlertConfig(title: "Success", message: "Upload was successful!", actions: [
                        UIAlertAction(title: "Ok", style: .default, handler: { alert in
                            self.next(step: RentalStep.dismiss)
                        })
                    ])))
                }, onError: { error in
                    self.isLoading.val = false
                    self.send(message: .msgBox(title: "Error", message: error.message))
                })
        } => disposeBag
    }
}
