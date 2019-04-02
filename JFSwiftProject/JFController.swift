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
        var string: String? = nil
        /**控制也能as到Any,但和nil又不等,总之右边是Any,肯定是可以转化成功且不为nil的*/
        let b = string as? Any
        if (b != nil) {
            print("")
        }

        /**Any的非可选类型,直接赋值nil会报错,但依然可以接受其它类型的nil值,这时候其结果类型为Any类型的nil,直接和nil比较将不相等*/
        /**1.赋值一个String?类型的nil变量,为str*/
        var str: String? = nil
        /**2.声明一个Any非可选类型变量a,赋值为str(nil),不是Any?类型的a接受nil并未报错,而是赋值为了一个Any类型的nil,可以理解为nil也是一个Any类型*/
        var a: Any = str
        /**3.而此时a内部的值nil和nil不相等,下面会进入断点print*/
        if (a != nil) {
            print("进来了")
        }

        self.navigationItem.title = "Jeffrey"
        self.vm.obGetRandJokes.andThen(.empty()).subscribe(onCompleted: {
            print("")
        }, onError: { error in
            print("")

        })
    }
}
