//
// Created by Attila AMBRUS on 2019-03-14.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Moya
import RxSwift

enum ReplaceAttachmentEndPoint {
    case list(eqId: String, emrId: String)
}

extension ReplaceAttachmentEndPoint: TargetType {
    public var baseURL: URL {
        return URL(string: AppDelegate.settings.apiUrl)!
    }

    public var path: String {
        switch self {
        case .list: return "/api/replaceattachmentlist"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .list: return .get
        }
    }

    public var sampleData: Data {
        fatalError("sampleData has not been implemented")
    }

    public var task: Task {
        switch self {
        case .list(let eqId, let emrId):
            return .requestParameters(parameters: ["eqId": eqId, "emrId": emrId], encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String: String]? {
        let deviceId = UIDevice.current.identifierForVendor!.uuidString

        switch self {
        case .list:
            return [
                "Content-type": "application/x-www-form-urlencoded",
                "DeviceId": deviceId,
                "X-ZUMO-AUTH": AppDelegate.instance.token!,
                "ZUMO-API-VERSION": "2.0.0"]
        }
    }
}

protocol ReplaceAttachment {
    func getAttachments(eqId: String, emrId: String) -> Single<[AttachmentModel]>
}
