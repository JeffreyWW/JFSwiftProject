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

    let input: (phone: Driver<String>, password: Driver<String>, agreementTap: Driver<Void>, nextTap: Driver<Void>, confirm: Driver<Bool>)

    init(input: (phone: Driver<String>, password: Driver<String>, agreementTap: Driver<Void>, nextTap: Driver<Void>, confirm: Driver<Bool>)) {
        self.input = input
    }

    lazy var output: (agreementSelected: Driver<Bool>, btnEnable: Driver<Bool>, needConfirm: Driver<Void>, loginResult: Driver<JFResult>) = {
        return (agreementSelected: self.agreementSelected, btnEnable: self.btnEnable, needConfirm: self.needConfirm, loginResult: self.loginResult)
    }()

    private var agreementSelected: Driver<Bool> {
        var selected = false
        return self.input.agreementTap.map { () -> Bool in
            selected = !selected
            return selected
        }.startWith(selected)
    }

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

    private var verification: Driver<String?> {
        return Driver.combineLatest(self.input.phone, self.input.password).map { (phone: String, password: String) -> String? in
            guard phone.count == 11 else {
                return "请输入正确的手机号"
            }

            guard password.count > 6 else {
                return "密码必须大于6位数"
            }
            return nil
        }
    }


    private var needConfirm: Driver<Void> {
        return self.input.nextTap.withLatestFrom(self.verification).flatMap { s in
            guard s == nil else {
                return Driver.never()
            }
            return Driver.just(())
        }
    }

    private var loginResult: Driver<JFResult> {
        return  self.input.confirm.filter { b in
            return b
        }.flatMap { b in
            return Driver.just(JFResult.success(JFApiResponse(result: 1)))
        }
    }

    var jokes: [Joke]? = []
//    lazy var obGetRandJokes = {
//        JFProviderManager.default.request(api: .getRandJokes).flatMapCompletable { response in
//            self.jokes = Mapper<Joke>().mapArray(JSONObject: response.result)
//            return Completable.empty()
//        }
//    }()
//    lazy var obLogin = {
//        return self.done.flatMap {
//            void -> Driver<JFResult> in
//            return JFProviderManager.default.request(api: .login(phone: "", password: ""))
//        }
//    }()
}
