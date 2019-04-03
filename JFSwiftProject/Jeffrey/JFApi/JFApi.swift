//
// Created by Jeffrey on 2019-03-28.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import RxSwift
import ObjectMapper
import SwiftyJSON

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
        return self.init(result: [:])
    }
}


enum JFApiError: Int, Error {
    case unknown
    //token失效
    case tokenLose
    //超过次数
    case tooManyTime = 100121

}

/**扩展请求,直接返回结果或者错误*/
extension MoyaProvider where Target == JFApi {
    func request(api: JFApi) -> Single<JFApiResponse> {
        return self.rx.request(api).asObservable().mapJSON().asSingle().catchError { error in
            return Single.error(error)
        }.flatMap { any -> Single<JFApiResponse> in
//            let errorCode = JSON(any)["error_code"].intValue
            let errorCode = 110
            //转化不了apiError,直接设置为默认
            guard errorCode == 0 else {
                guard let apiError = JFApiError(rawValue: errorCode) else {
                    return Single<JFApiResponse>.error(JFApiError.unknown)
                }
                return Single<JFApiResponse>.error(apiError)
            }
            return Single.just(JFApiResponse(JSON: any as! [String: Any])!)
        }
    }
}

enum TestError: Int {
    case T1 = 10012
}

/**apis*/
enum JFApi {
    /**获取随机笑话*/
    case getRandJokes
    /**登录*/
    case login(phone: String, password: String)

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