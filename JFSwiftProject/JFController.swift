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


class JFController: UIViewController {
    let disposeBag = DisposeBag()
    let vm = JFHomeViewModel.init()
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lbTest: UILabel!
    @IBOutlet weak var btnTest: UIButton!
    let obTest = Observable<String>.create { observer in
        print("2")
        observer.onNext("1111")
        observer.onError(JFApiError.tooManyTime)
//        observer.onCompleted()
        return Disposables.create()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
//        let dr: Driver = Driver.combineLatest(self.txtPhone.rx.text.orEmpty.asDriver(), self.txtPassword.rx.text.orEmpty.asDriver())
//        self.btnTest.rx.tap.asDriver().withLatestFrom(dr).flatMap { () -> SharedSequence<Sharing, R> in
//        }
//        Driver<Bool>.just(true).flatMap { e -> SharedSequence<Sharing, R> in
//        }


        //输入过滤的bool给到vm的check
//        self.txtTest.rx.text.map { s -> Bool in
//            return s!.count > 11
//        }.bind(to: self.vm.check)
        //vm的check值绑定到btn上,btn则会在输入11位后才enable
//        self.vm.check.bind(to: self.btnTest.rx.isEnabled)

    }

    @IBAction func clickToast() {
        let s2 = ("Jeff", "tom")
        s2.0
        Driver.just("1").flatMap { e -> Driver<String> in
            Driver.just("2")
        }.drive(onNext: { i in
            print(i)
        })

        //把错误转换为驱动的某值
        //input包含了所有的输入和选择(selected)等
        //输出设计:根据点击的时候和验证结果,为一个间接驱动
        //在间接基础上,会有一个提示的驱动,提示驱动作为输出,驱动控制器弹提示
        //在间接基础上,会有一个网络请求驱动,也是间接驱动
        //网络请求基础上,分为失败驱动和数据获取的驱动,以驱动当前控制器继续下一步操作
        //失败驱动驱动控制器扩展的分类某属性


    }

    @IBAction func clickHidden() {
        self.view.hideAllToasts()

    }
}
