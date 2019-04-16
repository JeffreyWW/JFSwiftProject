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


//vm只负责逻辑,弹窗等可以以驱动形式传入,vm负责拼接,具体的弹出则由vm书/**/写

class JFHomeViewModel: ReactiveCompatible {

    let input: (phone: Driver<String>, password: Driver<String>, agreementTap: Driver<Void>, nextTap: Driver<Void>, confirm: Driver<Bool>)

    init(input: (phone: Driver<String>, password: Driver<String>, agreementTap: Driver<Void>, nextTap: Driver<Void>, confirm: Driver<Bool>)) {
        self.input = input
    }


    lazy var output: (agreementSelected: Driver<Bool>, btnEnable: Driver<Bool>, needConfirm: Driver<Void>, showToast: Driver<String?>, startRequest: Driver<String?>, loginResult: Driver<JFResult>) = {
        return (agreementSelected: self.agreementSelected, btnEnable: self.btnEnable, needConfirm: self.needConfirm, showToast: self.showToast, startRequest: self.startRequest, loginResult: self.loginResult)
    }()

    /**是否选择协议,根据点击事件转换而来*/
    private var agreementSelected: Driver<Bool> {
        var selected = false
        return self.input.agreementTap.map { () -> Bool in
            selected = !selected
            return selected
        }.startWith(selected)
    }

    /**按钮的可用状态判断,两个输入都大于0才行*/
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


    /**校验,校验了手机号和密码位数以及是否选择了协议*/
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

    /**报错吐司驱动,基于校验*/
    private var showToast: Driver<String?> {
        return self.input.nextTap.withLatestFrom(self.verification)
    }


    /**弹出确认登录驱动,基于报错,若无报错则驱动弹出确认框*/
    private var needConfirm: Driver<Void> {
        return self.showToast.flatMap { s -> Driver<Void> in
            guard s == nil else {
                return Driver.never()
            }
            return Driver.just(())
        }
    }

    /**开始请求驱动,驱动转圈提示*/
    private var startRequest: Driver<String?> {
        return self.input.confirm.filter { b in
            return b
        }.flatMap { b in
            Driver.just("登录中")
        }
    }

    /**登录驱动,包含成功和失败*/
    private var loginResult: Driver<JFResult> {
        return self.startRequest.flatMap { s -> Driver<JFResult> in
            return JFProviderManager.default.request(api: .login(phone: "", password: "")).asDriver()
        }
    }

    var jokes: [Joke]? = []

}


