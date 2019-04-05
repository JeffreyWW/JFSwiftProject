//
// Created by Jeffrey on 2019-03-29.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper
import SwiftyJSON
import RxCocoa

class JFHomeViewModel: ReactiveCompatible {

    init() {
//        self.phone.map { s -> Bool in
//            return true
//        }.bind(to: self.check)
    }

    var checkPhone: BehaviorRelay<Bool?> = BehaviorRelay<Bool?>(value: true)
    var checkPwd: BehaviorRelay<Bool?> = BehaviorRelay<Bool?>(value: true)
    var checkPwdAgain: BehaviorRelay<Bool?> = BehaviorRelay<Bool?>(value: true)

    var phone: BehaviorRelay<String?> = BehaviorRelay<String?>(value: "")
    lazy var check: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    var jokes: [Joke]? = []
    lazy var obGetRandJokes = {
        JFProviderManager.default.request(api: .getRandJokes).flatMapCompletable { response in
            self.jokes = Mapper<Joke>().mapArray(JSONObject: response.result)
            return Completable.empty()
        }
    }()
    lazy var obLogin = {
        JFProviderManager.default.request(api: .login(phone: "", password: "")).flatMapCompletable { response in
            print("")
            return Completable.empty()
        }
    }()
}
