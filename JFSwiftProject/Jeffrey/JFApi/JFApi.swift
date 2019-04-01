//
// Created by Jeffrey on 2019-03-28.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import Alamofire

private let apiKey = "92328b1615ca6660414f482c7bf34050"

/**可以配多个全局的Provider*/
class JFProviderManager {
    static let `default` = MoyaProvider<JFApi>(plugins: [TestPlugins()])
}

/**结果,和api返回正常结果统一*/
struct JFApiResponse {
    var errorCode: Int?
}

/**错误,分为api返回的错误和系统错误(网络错误)*/
enum JFError {
    case system(error: JFSystemError)
    case api

    enum JFSystemError {
        case overTime
    }
}

/**扩展请求,直接返回结果或者错误*/
extension MoyaProvider where Target == JFApi {
    func test() {
        print("test")
    }
}

/**apis*/
enum JFApi {
    case login(phone: String, password: String)
    case home
}

/**moya协议*/
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
        return .requestParameters(parameters: parameters, encoding: JFEncoding.default)
    }
    public var headers: [String: String]? {
        return ["Content-Type": "application/   json"]
    }

}

/**自定义的编码方式,这里实现参数的加密等操作,名字可以改为例如Base64Encoding,DES3Encoding等*/
struct JFEncoding: ParameterEncoding {
    static var `default`: JFEncoding { return JFEncoding() }

    func encode(_ urlRequest: Alamofire.URLRequestConvertible, with parameters: Alamofire.Parameters?) throws -> URLRequest {
        var finalParameters: [String: Any] = [:]
        for (k, v) in parameters! {
            finalParameters[k] = v
        }
        finalParameters["key"] = apiKey
        return try URLEncoding.default.encode(urlRequest, with: finalParameters)
    }
}