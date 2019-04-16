//
// Created by Jeffrey on 2019-04-16.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private var bagKey = "bagKey"

extension UIViewController {
    var disposeBag: DisposeBag {
        guard let bag = objc_getAssociatedObject(self, &bagKey) as? DisposeBag else {
            let newDisposeBag = DisposeBag()
            objc_setAssociatedObject(self, &bagKey, newDisposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newDisposeBag
        }
        return bag
    }
}