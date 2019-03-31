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

class JFController: UIViewController {
    let vm = JFHomeViewModel.init()


    override func viewDidLoad() {
        super.viewDidLoad()
        let res = JFApiResponse()
        self.navigationItem.title = "Jeffrey"
        let provider = MoyaProvider<JFApi>()
        let ob = provider.rx.request(.home)
//        let ob2 = self.vm.obHome
        self.vm.obHome.subscribe(onNext: { value in
            let  s = value as! Dictionary<String,Any>
            let x = s["reason"] as! String
            print("")
//            let test = value as AnyObject
//            let x = test.raw
//            if let jsonData = value.data(using: String.Encoding.utf8, allowLossyConversion: false) {


//                do {
//                    let dic = ["key":["subKey":"subValue"]]
//                    let json = try JSON(data: jsonData).dictionary
//                    let reason  = json["reason"].string!
//                    print("")
//                } catch {
//                }

//            }

//            let dic = any as! Dictionary
//            let code = dic["reason"]
            print("")

//            do {
//                let json = any as! Dictionary<String, String>
//                let a = json["reason"] as String
//                print("")
//            } catch {
//            }


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
