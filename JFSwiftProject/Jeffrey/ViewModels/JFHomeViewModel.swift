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


    let input: (phone: Driver<String>, password: Driver<String>, nextTap: Driver<Void>, confirm: Driver<Bool>)

    init(input: (phone: Driver<String>, password: Driver<String>, nextTap: Driver<Void>, confirm: Driver<Bool>)) {
        self.input = input
    }

    lazy var output: (btnEnable: Driver<Bool>, done: Driver<Void?>) = {
        return (btnEnable: self.btnEnable, done: self.done)
    }()


    //变量之前无法引用,要引用则只能是懒加载或者计算
    private var btnEnable: Driver<Bool> {
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

    private var done: Driver<Void?> {
        return self.input.nextTap.flatMap { () -> Driver<Bool> in
            return self.input.confirm
        }.flatMap { b in
            return b ? Driver.just(nil) : Driver.never()
//            return Driver.just(nil)
        }
    }
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
