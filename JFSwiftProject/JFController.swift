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

class JFController: UIViewController {
    let vm = JFHomeViewModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Jeffrey"
        self.vm.obGetRandJokes.andThen(.empty()).subscribe(onCompleted: {
            print("")
        }, onError: { error in
            print("")
        })
        self.vm.obHome.subscribe()
    }
}
