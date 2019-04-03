//
// Created by Jeffrey on 2019-04-03.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    public func test() {

    }

}

extension Reactive where Base: UIViewController {
    public func test() {
print("123123123")
    }

    public func errorHandler(_ error: Error) -> Completable {
        return Completable.empty()
    }
}