//
// Created by Jeffrey on 2019-03-28.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya

/**可以配多个全局的Provider*/
class JFProviderManager {
    static let normal = MoyaProvider<JFApi>(plugins: [TestPlugins()])
}


struct JFApiResponse {
    var errorCode: Int?
}

enum JFError {
    case system(error: JFSystemError)
    case api

    enum JFSystemError {
        case overTime
    }
}

enum JFApi {
    case login(phone: String, password: String)
    case home
}

extension JFApi {
    var apiKey: String {
        return "92328b1615ca6660414f482c7bf34050"
//        return ""
    }
}


extension JFApi: TargetType {
    public var baseURL: URL {
        return URL(string: "http://v.juhe.cn/joke")!
    }
    public var path: String {
        switch self {
        case .login:
            return ""
        case .home:
            return "randJoke.php"
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
        parameters["key"] = self.apiKey
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

}

class aaa: Decodable {

}