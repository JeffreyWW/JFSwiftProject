//
// Created by Jeffrey on 2019-03-29.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class JFHomeViewModel {
    let data = ""
    lazy var obHome = {
        JFProviderManager.`default`.rx.request(.home).asObservable().mapString()
    }()
    lazy var obLogin = {
        JFProviderManager.`default`.rx.request(.login(phone: "", password: "")).asObservable().mapString()
    }()
}
