//
// Created by Jeffrey on 2019-04-03.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya

/**解决AC无法读取rx类型问题*/
extension UIViewController {
    public var rx: Reactive<UIViewController> {
        get {
            return Reactive(self)
        }
    }
}


extension Reactive where Base: UIViewController {
    public func catchError(_ error: Error) -> Completable {
        var finalCatchError: Completable = Completable.empty()
        if let apiError = error as? JFApiError {
            finalCatchError = self.base.errorHandler(apiError)
        }

        if let moyaError = error as? MoyaError {
            finalCatchError = self.base.errorHandler(moyaError)
        }

        if let localError = error as? JFLocalError {
            finalCatchError = self.base.errorHandler(localError)
        }
        return self.base.hud.rx.stopLoading.andThen(finalCatchError)
    }
}

private extension UIViewController {
    func errorHandler(_ apiError: JFApiError) -> Completable {
        switch (apiError) {
        case .unknown:
            return self.hud.rx.showMessage("后台系统异常,请稍后重试")
        case .tokenLose:
            //需要登出效果
            return self.hud.rx.showMessage("登录失效,请重新登录")
        case .tooManyTime:
            return self.hud.rx.showMessage("请求已超过次数")
        }
    }
}

private extension UIViewController {
    func errorHandler(_ moyaError: MoyaError) -> Completable {
        return Completable.empty().andThen(self.hud.rx.showMessage("网络错误"))
    }
}

private extension UIViewController {
    func errorHandler(_ localError: JFLocalError) -> Completable {
        return Completable.empty().andThen(self.hud.rx.showMessage("本地错误"))
    }
}