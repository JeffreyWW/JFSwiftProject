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

class JFController: UIViewController {
    let vm = JFHomeViewModel.init()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Jeffrey"
        let provider = MoyaProvider<JFApi>()
        let ob = provider.rx.request(.home)
//        let ob2 = self.vm.obHome
        self.vm.obHome.subscribe(onNext: { any in print(any)  }, onError: { error in
            print(error)
        })
        self.vm.obLogin.subscribe(onNext: { any in }, onCompleted: {

        })
        // Do any additional setup after loading the view, typically from a nib.
    }
}
