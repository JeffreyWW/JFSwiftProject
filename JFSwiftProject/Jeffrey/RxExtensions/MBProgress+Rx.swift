//
// Created by Jeffrey on 2019-04-02.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import MBProgressHUD
import RxSwift
import RxCocoa

private var hudKey = "hudKey"


/**扩展控制器,都可以自带一个hud*/
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


/**扩展hud*/
extension Reactive where Base: MBProgressHUD {
    /**hidden,可作为驱动停止并驱动操作,也可仅作为监听只是停止转圈*/
    var hidden: ControlProperty<Void> {
        return ControlProperty(values: Observable<Void>.create { observer in
            self.base.completionBlock = {
                observer.onNext(())
            }
            self.base.hide(animated: true)
            return Disposables.create()
        }, valueSink: Binder<Void>(self.base) { (target: MBProgressHUD, void: Void) in
            self.base.hide(animated: true)
        })
    }

    /**作为监听,监听转圈*/
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


    /**作为驱动的toast,驱动执行在结束以后*/
    func toast(message: String?) -> Driver<Void> {
        return Observable<Void>.create { observer in
            guard message != nil else {
                return Disposables.create()
            }
            self.base.mode = MBProgressHUDMode.text
            self.base.detailsLabel.text = message
            self.base.completionBlock = {
                observer.onNext(())
            }
            self.base.show(animated: true)
            self.base.hide(animated: true, afterDelay: 2)
            return Disposables.create()
        }.asDriver(onErrorDriveWith: Driver.never())
    }

    var toast: Binder<String?> {
        return Binder(self.base) { (target: MBProgressHUD, message: String?) in
            guard message != nil else {
                return
            }
            self.base.mode = MBProgressHUDMode.text
            self.base.detailsLabel.text = message
            self.base.completionBlock = nil
            self.base.show(animated: true)
            self.base.hide(animated: true, afterDelay: 2)
        }
    }
}
