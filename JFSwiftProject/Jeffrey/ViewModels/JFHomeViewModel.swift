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

//vm只负责逻辑,弹窗等可以以驱动形式传入,vm负责拼接,具体的弹出则由vm书写
class JFHomeViewModel: ReactiveCompatible {

    let input: (phone: Driver<String>, password: Driver<String>, nextTap: Driver<Void>, confirm: Driver<Bool>)

    init(input: (phone: Driver<String>, password: Driver<String>, nextTap: Driver<Void>, confirm: Driver<Bool>)) {
        self.input = input
    }

    lazy var output: (btnEnable: Driver<Bool>, needConfirm: Driver<Void>, loginResult: Driver<JFResult>) = {
        return (btnEnable: self.btnEnable, needConfirm: self.needConfirm, loginResult: self.loginResult)
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
    private var needConfirm: Driver<Void> {
        return self.input.nextTap.flatMap {
            Driver.just(())
        }
    }

    private var loginResult: Driver<JFResult> {
        return   self.input.confirm.filter { b in
            return b
        }.flatMap { b in
            return Driver.just(JFResult.success(JFApiResponse(result: 1)))
        }
    }
    private var done: Driver<Void?> {
        return self.input.nextTap.flatMap { () -> Driver<Bool> in
            return self.input.confirm
        }.flatMap { b in
            return b ? Driver.just(nil) : Driver.never()
        }
    }


    var jokes: [Joke]? = []
//    lazy var obGetRandJokes = {
//        JFProviderManager.default.request(api: .getRandJokes).flatMapCompletable { response in
//            self.jokes = Mapper<Joke>().mapArray(JSONObject: response.result)
//            return Completable.empty()
//        }
//    }()
    lazy var obLogin = {
        return self.done.flatMap {
            void -> Driver<JFResult> in
            return JFProviderManager.default.request(api: .login(phone: "", password: ""))
        }
    }()
}
