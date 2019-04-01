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
        JFProviderManager.normal.rx.request(.home).asObservable().mapString()
    }()
    lazy var obLogin = {
        JFProviderManager.normal.rx.request(.login(phone: "", password: "")).asObservable().mapString()
    }()
}
