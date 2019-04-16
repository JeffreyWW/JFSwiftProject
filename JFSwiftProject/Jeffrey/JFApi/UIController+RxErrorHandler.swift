//
// Created by Jeffrey on 2019-04-03.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya

/**统一入口*/
extension Reactive where Base: UIViewController {
    var errorBinder: Binder<Error> {
        return Binder(self.base) { (target: UIViewController, error: Error) in
            var binder: AnyObserver<Error>? = nil
            if let apiError = error as? JFApiError {
                binder = self.apiErrorBinder(e: apiError)
            }

            if let moyaError = error as? MoyaError {
                binder = self.moyaErrorBinder(e: moyaError)
            }

            self.base.hud.rx.hidden.asDriver().flatMap { () -> Driver<Error> in
                Driver.just(error)
            }.drive(binder!).disposed(by: self.base.disposeBag)
        }
    }
}

/**不同类型错误处理方式*/
private extension Reactive where Base: UIViewController {
    func apiErrorBinder(e: JFApiError) -> AnyObserver<Error> {
        switch e {
        default:
            return self.base.hud.rx.toast.mapObserver { (e: Error) in
                "api错误"
            }
        }
    }

    func moyaErrorBinder(e: MoyaError) -> AnyObserver<Error> {
        switch e {
        default:
            return self.base.hud.rx.toast.mapObserver { (e: Error) in
                "系统错误"
            }
        }
    }
}


