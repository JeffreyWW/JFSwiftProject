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
import RxCocoa

let kJuHeBaseUrl = "http://v.juhe.cn/joke"
private let juHeApiKey = "92328b1615ca6660414f482c7bf34050"

/**可以配多个全局的Provider*/
class JFProviderManager {
    static let `default` = MoyaProvider<JFApi>(plugins: [TestPlugins()])
}

enum JFResult {
    case success(JFApiResponse)
    case failure(Error)
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


//内部设置后,api的错误必然会匹配,要么是unknown,要么是其他类型
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
    func newRequest(api: JFApi) -> Observable<JFResult> {
        return self.rx.request(api).asObservable().mapJSON().flatMap { any -> Observable<JFResult> in
            let errorCode = JSON(any)["error_code"].intValue
//            let errorCode = 12123
            //守卫,必须为0,否则是失败
            guard errorCode == 0 else {
                //失败,通过错误码匹配枚举,匹配不到设置为known类型并问后台具体错误码表示的意义,添加到错误没居中去匹配
                guard let apiError = JFApiError(rawValue: errorCode) else {
                    return Observable<JFResult>.error(JFApiError.unknown)
                }
                //匹配到的直接设置
                return Observable<JFResult>.just(.failure(apiError))
            }
            //通过==0的守卫则成功,把数据发送出去
            return Observable<JFResult>.just(.success(JFApiResponse(JSON: any as! [String: Any])!))
        }.catchError { error in
            Observable.just(JFResult.failure(error))
        }
    }


    func request(api: JFApi) -> Driver<JFResult> {
        return self.rx.request(api).asObservable().mapJSON().flatMap { any -> Observable<JFResult> in
            let errorCode = JSON(any)["error_code"].intValue
//            let errorCode = 12123
            //守卫,必须为0,否则是失败
            guard errorCode == 0 else {
                //失败,通过错误码匹配枚举,匹配不到设置为known类型并问后台具体错误码表示的意义,添加到错误没居中去匹配
                guard let apiError = JFApiError(rawValue: errorCode) else {
                    return Observable<JFResult>.error(JFApiError.unknown)
                }
                //匹配到的直接设置
                return Observable<JFResult>.just(.failure(apiError))
            }
            //通过==0的守卫则成功,把数据发送出去
            return Observable<JFResult>.just(.success(JFApiResponse(JSON: any as! [String: Any])!))
        }.asDriver { error in
            Driver.just(JFResult.failure(error))
        }
    }
}

//扩展的时候,如果是typealias,泛型需要之前的
extension Observable where Element == JFResult {
    func asResultDriver() -> Driver<JFResult> {
        return self.asDriver { (error: Error) -> Driver<JFResult> in
            return Driver.just(JFResult.failure(error))
        }
    }
}

extension Driver where Element == JFApiResponse {
    func asVoid() -> Driver<Void> {
        return self.flatMap { element -> Driver<Void> in
            return Driver.just(())
        }
    }
}

extension Driver where Element == JFResult {
    func asSuccess() -> Driver<JFApiResponse> {
        return self.flatMap { (result: JFResult) -> Driver<JFApiResponse> in
            switch result {
            case let .success(response):
                return Driver.just(response)
            case .failure:
                return Driver.never()
            }
        }
    }

    func asFailure() -> Driver<Error> {
        return self.flatMap { (result: JFResult) -> Driver<Error> in
            switch result {
            case .success:
                return Driver.never()
            case let .failure(error):
                return Driver.just(error)
            }
        }
    }

}

//extension Driver where SharedSequenceConvertibleType == Any {
//
//    func test() {
//
//
//    }
//
//}

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