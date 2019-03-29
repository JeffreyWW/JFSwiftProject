//
// Created by Jeffrey on 2019-03-28.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya


class JFApiProvider: MoyaProvider<JFApi> {
    static let normal = JFApiProvider(plugins: [TestPlugins()])
}

enum JFApi {
    case login(phone: String, password: String)
    case home
}

extension JFApi: TargetType {
    public var baseURL: URL {
        return URL(string: "https://www.baidu.com")!
    }
    public var path: String {
        switch self {
        case .login:
            return ""
        case .home:
            return ""
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var sampleData: Data {
        return Data.init()
    }
    public var task: Task {
        var parameters: [String: Any] = [:]
        switch self {
        case let .login(phone, password):
            parameters = ["phone": phone, "password": password]
        case .home:
            parameters = ["home": "lalala"]
        default:
            break
        }

        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    public var headers: [String: String]? {
        return nil
    }

}
