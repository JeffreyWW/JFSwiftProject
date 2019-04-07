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
    //输入必须确定,输出其实也必须会确定,但那样的话,必须在初始化就写出如何输出,内部的每个输出无法用单独的变量,因为
    //索性用lazy
    let input: (phone: Driver<String>, password: Driver<String>)

    init(input: (phone: Driver<String>, password: Driver<String>)) {
        self.input = input
    }

    lazy var output: (btnEnable: Driver<Bool>, done: Driver<Bool>) = {
        return (btnEnable: self.btnEnable, done: Driver.just(true))
    }()


    //变量之前无法引用,要引用则只能是懒加载或者计算
    var btnEnable: Driver<Bool> {
        let phoneHasInput = self.input.phone.map { s -> Bool in
            s.count > 0
        }
        let passwordHasInput = self.input.password.map { s -> Bool in
            s.count > 0
        }
        return Driver.combineLatest(phoneHasInput, passwordHasInput).map { phone, password -> Bool in
            return phone && password
        }
    }


//    lazy var output: (btnEnable: Driver<Bool>, done: Driver<Bool>) = {
//        return (btnEnable: self.btnEnable, done: Driver.just(false))
//    }()

//    private lazy var btnEnable = {
//        return Driver.just(true)
//    }()


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
