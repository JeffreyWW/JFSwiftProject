//
//  JFController.swift
//  JFSwiftProject
//
//  Created by Jeffrey on 2019/3/28.
//  Copyright © 2019年 CrfChina. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import SwiftyJSON
import ObjectMapper
import Toast_Swift
import RxCocoa
import SnapKit
import PKHUD
import MBProgressHUD

class JFController: JFBaseController {
    let vm = JFHomeViewModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = "Jeffrey"
//        self.vm.obGetRandJokes.andThen(.empty()).subscribe(onCompleted: {
//            print("")
//        }, onError: { error in
//            print("")
//        })
//        self.vm.obLogin.subscribe()
    }

    @IBAction func clickToast() {

        self.hud.rx.loading("加载中")
                .andThen(self.vm.obGetRandJokes)
                .andThen(self.hud.rx.stopLoading)
                .andThen(self.hud.rx.showMessage("登录完成"))
                .catchError { error in
                    let a = error as? JFError
                    print("")
                    return Completable.empty()
                }
                .subscribe()
    }

    @IBAction func clickHidden() {
        self.view.hideAllToasts()
    }
}
