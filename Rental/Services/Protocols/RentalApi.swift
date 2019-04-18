//
// Created by Attila AMBRUS on 2019-03-14.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Moya
import RxSwift

enum RentalApiEndPoints {
    case replaceAttachmentList(eqId: String, emrId: String)
    case uploadPhoto(recId: String, base64Data: String, fileName: String)
    case partialPostEMR(lineIds: String)
}

extension RentalApiEndPoints: TargetType {
    public var baseURL: URL {
        return URL(string: AppDelegate.settings.apiUrl)!
    }

    public var path: String {
        switch self {
        case .replaceAttachmentList: return "/api/replaceattachmentlist"
        case .uploadPhoto: return "/api/rentalimageupload"
        case .partialPostEMR: return "/api/rental/partialpostemr"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .replaceAttachmentList: return .get
        case .uploadPhoto: return .post
        case .partialPostEMR: return .post
        }
    }

    public var sampleData: Data {
        fatalError("sampleData has not been implemented")
    }

    public var task: Task {
        switch self {
        case .replaceAttachmentList(let eqId, let emrId):
            return .requestParameters(parameters: ["eqId": eqId, "emrId": emrId], encoding: URLEncoding.queryString)
        case .uploadPhoto(let recId, let base64Data, let fileName):
            return .requestParameters(parameters: ["recId": recId, "base64Data": base64Data, "fileName": fileName], encoding: URLEncoding.httpBody)
        case .partialPostEMR(let lineIds):
            return .requestParameters(parameters: ["lineIds": lineIds], encoding: URLEncoding.httpBody)
        }
    }

    public var headers: [String: String]? {
        let deviceId = UIDevice.current.identifierForVendor!.uuidString

        switch self {
        case .replaceAttachmentList, .uploadPhoto, .partialPostEMR:
            return [
                "Content-type": "application/x-www-form-urlencoded",
                "DeviceId": deviceId,
                "X-ZUMO-AUTH": AppDelegate.instance.token!,
                "ZUMO-API-VERSION": "2.0.0"]
        }
    }
}

protocol RentalApi {
    func getReplaceAttachmentList(eqId: String, emrId: String) -> Single<[AttachmentModel]>
    func uploadPhoto(_ params: UploadPhotoParams) -> Completable
    func partialPostEMR(_ lineIds: String) -> Completable
}

struct UploadPhotoParams {
    var recId: String
    var base64Data: String
    var fileName: String
}
