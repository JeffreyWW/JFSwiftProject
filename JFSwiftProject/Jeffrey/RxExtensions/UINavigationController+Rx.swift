//
// Created by Jeffrey on 2019-04-16.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

extension Reactive where Base: UINavigationController {
    /**跳转监听*/
    var push: Binder<UIViewController> {
        return self.pushAnimate(animated: true)
    }
    /**跳转监听,无动画*/
    var pushStatic: Binder<UIViewController> {
        return self.pushAnimate(animated: false)
    }

    private func pushAnimate(animated: Bool) -> Binder<UIViewController> {
        return Binder<UIViewController>(self.base) { (navigationController: UINavigationController, controller: UIViewController) in
            navigationController.pushViewController(controller, animated: animated)
        }
    }
}