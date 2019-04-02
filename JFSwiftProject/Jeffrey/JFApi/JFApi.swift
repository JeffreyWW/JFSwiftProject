//
// Created by Jeffrey on 2019-03-28.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import RxSwift
import ObjectMapper

let kJuHeBaseUrl = "http://v.juhe.cn/joke"
private let juHeApiKey = "92328b1615ca6660414f482c7bf34050"

/**可以配多个全局的Provider*/
class JFProviderManager {
    static let `default` = MoyaProvider<JFApi>(plugins: [TestPlugins()])
}

/**结果,和api返回正常结果统一,这里以聚合的接口为例*/
struct JFApiResponse: Mappable {
    var result: Any?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        result <- map["result"]
    }

    init(result: Any?) {
        self.result = result
    }

    static func success() -> JFApiResponse {
        return self.init(result: [:] as Any)
    }
}

/**错误,分为api返回的错误和系统错误(网络错误)*/
enum JFError: Error {
    case system(error: JFSystemError)
    case api

    enum JFSystemError {
        case overTime
    }
}

/**扩展请求,直接返回结果或者错误*/
extension MoyaProvider where Target == JFApi {
    func request(api: JFApi) -> Single<JFApiResponse> {
        return self.rx.request(api).asObservable().mapJSON().asSingle().map { any -> JFApiResponse in
            return JFApiResponse(JSON: any as! [String: Any])!
        }
    }
}

/**apis*/
enum JFApi {
    /**获取随机笑话*/
    case getRandJokes
//    case login(phone: String, password: String)

}


/**moya协议*/
extension JFApi: TargetType {
    public var baseURL: URL {
        return URL(string: kJuHeBaseUrl)!
    }

    public var path: String {
        switch self {
        case .getRandJokes:
            return "randJoke.php"
        default:
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
        return .requestParameters(parameters: [:], encoding: JFEncoding.default)
    }
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

}

/**自定义的编码方式,这里实现参数的加密等操作,名字可以改为例如Base64Encoding,DES3Encoding等*/
struct JFEncoding: ParameterEncoding {
    static var `default`: JFEncoding {
        return JFEncoding()
    }

    func encode(_ urlRequest: Alamofire.URLRequestConvertible, with parameters: Alamofire.Parameters?) throws -> URLRequest {
        var finalParameters: [String: Any] = [:]
        for (k, v) in parameters! {
            finalParameters[k] = v
        }
        finalParameters["key"] = juHeApiKey
        return try URLEncoding.default.encode(urlRequest, with: finalParameters)
    }
}