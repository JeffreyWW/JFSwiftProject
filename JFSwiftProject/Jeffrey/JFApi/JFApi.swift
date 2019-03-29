//
// Created by Jeffrey on 2019-03-28.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya

enum JFApi {
    case login(phone: String, passwd: String)
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
        switch self {
        case let .login(phone, passwd):
            return .requestParameters(parameters: ["phone": phone, "password": passwd], encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        }
    }
    public var headers: [String: String]? {
        return nil
    }

}
