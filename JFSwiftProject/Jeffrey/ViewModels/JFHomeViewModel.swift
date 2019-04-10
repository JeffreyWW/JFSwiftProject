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

    lazy var output: (agreementSelected: Driver<Bool>, btnEnable: Driver<Bool>, needConfirm: Driver<Void>, showToast: Driver<String?>, startRequest: Driver<String?>, loginResult: Driver<JFResult>) = {
        return (agreementSelected: self.agreementSelected, btnEnable: self.btnEnable, needConfirm: self.needConfirm, showToast: self.showToast, startRequest: self.startRequest, loginResult: self.loginResult)
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
        return Driver.combineLatest(self.input.phone, self.input.password, self.agreementSelected).map { (phone: String, password: String, agreementSelected: Bool) -> String? in
            guard phone.count == 11 else {
                return "请输入正确的手机号"
            }

            guard password.count > 6 else {
                return "密码必须大于6位数"
            }
            guard agreementSelected else {
                return "请先勾选协议"
            }
            return nil
        }
    }

    //点击,返回报错的字符串
    private var showToast: Driver<String?> {
        return self.input.nextTap.withLatestFrom(self.verification)
    }


    private var needConfirm: Driver<Void> {
        return self.showToast.flatMap { s -> Driver<Void> in
            guard s == nil else {
                return Driver.never()
            }
            return Driver.just(())
        }
    }

    private var startRequest: Driver<String?> {
        return self.input.confirm.filter { b in
            return b
        }.flatMap { b in
            Driver.just("登录中,请稍后")
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

}
