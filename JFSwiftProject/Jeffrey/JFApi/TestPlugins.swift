//
// Created by Jeffrey on 2019-03-29.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import Result

class TestPlugins: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }

    func willSend(_ request: RequestType, target: TargetType) {
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    }

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
}
