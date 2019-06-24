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
    case createEMRLine(operation: Int, type: Int, equipmentId: String, itemId: String, emrId: String,
                       toInvLoc: String, toWMSLoc: String, direction: Int, quantity: Int, fuelLevel: Int, smu: Int, secondarySMU: Int,
                       deliveryNotes: String, notes: String)
}

extension RentalApiEndPoints: TargetType {
    public var baseURL: URL {
        return URL(string: AppDelegate.settings.apiUrl)!
    }

    public var path: String {
        switch self {
        case .replaceAttachmentList: return "/api/replaceattachmentlist"
        case .uploadPhoto: return "/api/rentalimageupload"
        case .partialPostEMR: return "/api/rentalpartialpostemr"
        case .createEMRLine: return "/api/rentalcreateemrline"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .replaceAttachmentList: return .get
        case .uploadPhoto: return .post
        case .partialPostEMR: return .post
        case .createEMRLine: return .post
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
        case .createEMRLine(let operation, let type, let equipmentId, let itemId, let emrId, let toInvLoc, let toWMSLoc, let direction, let quantity, let fuelLevel, let smu, let secondarySMU, let deliveryNotes, let notes):
            return .requestParameters(parameters: ["operation": operation, "type": type, "equipmentId": equipmentId,
                                                   "itemId": itemId, "emrId": emrId, "toInvLoc": toInvLoc, "toWMSLoc": toWMSLoc,
                                                   "direction": direction, "quantity": quantity, "fuelLevel": fuelLevel, "smu": smu, "secondarySMU": secondarySMU,
                                                   "deliveryNotes": deliveryNotes, "notes": notes], encoding: URLEncoding.httpBody)
        }
    }

    public var headers: [String: String]? {
        let deviceId = UIDevice.current.identifierForVendor!.uuidString

        switch self {
        case .replaceAttachmentList, .uploadPhoto, .partialPostEMR, .createEMRLine:
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
    func createEMRLine(_ params: CreateEMRParams) -> Completable
}

struct UploadPhotoParams {
    var recId: String
    var base64Data: String
    var fileName: String
}

struct CreateEMRParams {
    var operation: Int
    var type: Int
    var equipmentId: String
    var itemId: String
    var emrId: String
    var toInvLoc: String
    var toWMSLoc: String
    var direction: Int
    var quantity: Int
    var fuelLevel: Int
    var smu: Int
    var secondarySMU: Int
    var deliveryNotes: String
    var notes: String
}
