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
    lazy var vm: JFHomeViewModel = {
        let phone = self.txtPhone.rx.text.orEmpty.asDriver()
        let password = self.txtPassword.rx.text.orEmpty.asDriver()
        let nextTap = self.btnNext.rx.tap.asDriver()
        let confirm = self.confirm
        return JFHomeViewModel(input: (phone: phone, password: password, nextTap: nextTap, confirm: confirm))
    }()
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lbTest: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    var confirm: Driver<Bool> {
        return Observable<Bool>.create { observer in
            let controller = UIAlertController(title: "提示", message: "消息", preferredStyle: .alert)
            let action = UIAlertAction(title: "取消", style: .cancel) { action in
                observer.onNext(false)
                observer.onCompleted()
            }
            let confirm = UIAlertAction(title: "确定", style: .default) { action in
                observer.onNext(true)
                observer.onCompleted()
            }
            controller.addAction(action)
            controller.addAction(confirm)
            self.present(controller, animated: true)
            return Disposables.create()
        }.asDriver(onErrorJustReturn: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.binding()
        self.asObserver()

    }


    private func binding() {

    }

    private func asObserver() {
        //驱动按钮可用
        self.vm.output.btnEnable.drive(self.btnNext.rx.isEnabled)
        self.vm.output.done.drive(onNext: { i in
            print("111")
        })

        //传入一个提示符

    }

    @IBAction func clickToast() {

        //提示确认还是取消
//        let a = Observable.create { (observer: AnyObserver<Element>) in  }.asDriver(onErrorJustReturn: false)

        //把错误转换为驱动的某值
        //input包含了所有的输入和选择(selected)等,并包含了一个确认驱动,此驱动依赖点击了确定还是取消,分别为true和false,
        //输出设计:根据点击的时候和验证结果,为一个间接驱动
        //在间接基础上,会有一个错误提示的驱动,提示驱动作为输出,驱动控制器弹提示
        //简洁基础上,会有一个提示确定继续的驱动,驱动外部点击取消还是确认,确认just"true"
        //在间接基础上,会有一个网络请求驱动,也是间接驱动
        //网络请求基础上,分为失败驱动和数据获取的驱动,以驱动当前控制器继续下一步操作
        //失败驱动驱动控制器扩展的分类某属性


    }

    @IBAction func clickHidden() {
        self.view.hideAllToasts()

    }
}
