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
        let res  = JFApiResponse()
        self.navigationItem.title = "Jeffrey"
        let provider = MoyaProvider<JFApi>()
        let ob = provider.rx.request(.home)
//        let ob2 = self.vm.obHome
        self.vm.obHome.subscribe(onNext: { any in
//            let dic = any as! Dictionary<String, String>
//            let code = dic["reason"]
            print(any)
        }, onError: { error in
            print(error)
        })
        let e = JFError.system(error: .overTime)
        switch e {
        case .api:
            print("")
        case let .system(error):
            switch error {
            case .overTime:
                break
            }
            print("")
        }
//        self.vm.obLogin.subscribe(onNext: { any in }, onCompleted: {
//
//        })

    }
}
