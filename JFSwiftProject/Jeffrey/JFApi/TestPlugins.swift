//
// Created by Jeffrey on 2019-03-29.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import Result
import ObjectMapper

extension JFApi {
    fileprivate var useLocalData: Bool {
        switch self {
        case .login:return true
        default:return false
        }
    }

    fileprivate var result: Any? {
        var finalResult: Any? = nil
        switch self {
        case let .login(phone, password):
            finalResult = ["message": "登录成功"]
        default:finalResult = nil
        }
        return finalResult
    }
}

class TestPlugins: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }

    func willSend(_ request: RequestType, target: TargetType) {
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    }

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        if let api = target as? JFApi {
            if (api.result != nil && api.useLocalData) {
                let apiResponseData = JFApiResponse(result: api.result).toJSONString()?.data(using: .utf8)
                let finalResponse = Response(statusCode: 200, data: apiResponseData!)
                return .success(finalResponse)
            }
        }

        return result
    }
}
