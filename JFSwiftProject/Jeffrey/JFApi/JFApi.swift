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
    //内部将没有匹配具体数值的错误设置为unknown,尽量去问后台,将错误类型匹配好
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
            //获取错误码
            let errorCode = JSON(any)["error_code"].intValue
            //守卫,必须为0,否则是失败
            guard errorCode == 0 else {
                //失败,通过错误码匹配枚举,匹配不到设置为known类型并问后台具体错误码表示的意义,添加到错误没居中去匹配
                guard let apiError = JFApiError(rawValue: errorCode) else {
                    return Single<JFApiResponse>.error(JFApiError.unknown)
                }
                //匹配到的直接设置
                return Single<JFApiResponse>.error(apiError)
            }
            //通过==0的守卫则成功,把数据发送出去
            return Single.just(JFApiResponse(JSON: any as! [String: Any])!)
        }
    }
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