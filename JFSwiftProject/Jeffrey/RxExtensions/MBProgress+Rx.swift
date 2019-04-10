//
// Created by Jeffrey on 2019-04-02.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import MBProgressHUD
import RxSwift
import RxCocoa

private var hudKey = "hudKey"


extension UIViewController {
    var hud: MBProgressHUD {
        guard let hud = objc_getAssociatedObject(self, &hudKey) as? MBProgressHUD else {
            let hudNew = MBProgressHUD.default(view: self.view)
            objc_setAssociatedObject(self, &hudKey, hudNew, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return hudNew
        }
        return hud
    }
}

extension Reactive where Base: MBProgressHUD {
    var loading: Binder<String?> {
        return Binder(self.base) { (target: MBProgressHUD, value: String?) in
            guard value != nil else {
                return
            }
            self.base.mode = MBProgressHUDMode.indeterminate
            self.base.detailsLabel.text = value
            self.base.show(animated: true)
        }
    }
    var showMessage: Binder<String?> {
        return Binder(self.base) { (target: MBProgressHUD, value: String?) in
            guard value != nil else {
                return
            }
            self.base.mode = MBProgressHUDMode.text
            self.base.detailsLabel.text = value
            self.base.show(animated: true)
            self.base.hide(animated: true, afterDelay: 2)
        }
    }
}

extension Reactive where Base: MBProgressHUD {


    public func loading(_ message: String?) -> Completable {
        return Completable.create { observer in
            self.base.mode = MBProgressHUDMode.indeterminate
            self.base.detailsLabel.text = message
            self.base.show(animated: true)
            observer(.completed)
            return Disposables.create()
        }
    }

    var stopLoading: Completable {
        return Completable.create { observer in
            self.base.completionBlock = {
                observer(.completed)
            }
            self.base.hide(animated: true)
            return Disposables.create()
        }
    }


    public func showMessage(_ message: String?) -> Completable {
        return Completable.create { observer in
            self.base.mode = MBProgressHUDMode.text
            self.base.detailsLabel.text = message
            self.base.completionBlock = {
                observer(.completed)
            }
            self.base.show(animated: true)
            self.base.hide(animated: true, afterDelay: 2)
            return Disposables.create()
        }
    }
}