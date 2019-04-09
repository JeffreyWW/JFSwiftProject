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
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lbTest: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    let disposeBag = DisposeBag()
    lazy var vm: JFHomeViewModel = {
        let phone = self.txtPhone.rx.text.orEmpty.asDriver()
        let password = self.txtPassword.rx.text.orEmpty.asDriver()
        let nextTap = self.btnNext.rx.tap.asDriver()
        let confirm = self.confirm
        return JFHomeViewModel(input: (phone: phone, password: password, nextTap: nextTap, confirm: confirm))
    }()
    var confirm: Driver<Bool> {
        return self.confirmAction.asDriver(onErrorJustReturn: false)
    }
    private let confirmAction: PublishSubject<Bool> = PublishSubject()
    var confirmAlert: Binder<Void> {
        return Binder(self) { (target: UIViewController, value: Void) in
            let controller = UIAlertController(title: "提示", message: "确认登录么", preferredStyle: .alert)
            let action = UIAlertAction(title: "取消", style: .cancel) { action in
                self.confirmAction.onNext(false)
            }
            let confirm = UIAlertAction(title: "确定", style: .default) { action in
                self.confirmAction.onNext(true)
            }
            controller.addAction(action)
            controller.addAction(confirm)
            self.present(controller, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.asObserver()
        self.btnNext.rx.tap
    }

    private func asObserver() {
        //登录按钮可用
        self.vm.output.btnEnable.drive(self.btnNext.rx.isEnabled)
        self.vm.output.needConfirm.drive(self.confirmAlert)
        //成功转化为无结果驱动驱动确认弹窗
//        self.vm.output.loginResult.asSuccess().asVoid().drive(self.confirmAlert)
//        self.btnNext.rx.tap.asDriver().drive(self.confirmAlert)

//        self.vm.obLogin.asFailure().

        //catch返回结果必然是对应的,所以,结果catch来说应该也是,但catch不需要发送值,只需要完成,咋办,所以catch应该是ob类型,然外面自由转换即可
//        self.vm.obLogin.asDriver(onErrorRecover: <#T##@escaping (Error) -> Driver<JFApiResponse>##@escaping (Swift.Error) -> RxCocoa.Driver<JFSwiftProject.JFApiResponse>#>)

//        self.vm.obLogin.catchError(<#T##handler: @escaping (Error) throws -> PrimitiveSequence<SingleTrait, JFApiResponse>##@escaping (Swift.Error) throws -> RxSwift.PrimitiveSequence<RxSwift.SingleTrait, JFSwiftProject.JFApiResponse>#>)
//        self.vm.obLogin.catchError(<#T##handler: @escaping (Error) throws -> PrimitiveSequence<SingleTrait, JFApiResponse>##@escaping (Swift.Error) throws -> RxSwift.PrimitiveSequence<RxSwift.SingleTrait, JFSwiftProject.JFApiResponse>#>)
//maybe 转不了com,因为next和com是互斥的,s能转,理论上s发送完值后会com

        //转化为drive的时候,先catch,错误则设置为never,不会返回
//        self.vm.obLogin.asDriver { error in
//            self.rx.catchError(error).fla
//        }
//        Completable.empty().asDriver(onErrorDriveWith: Driver.empty()).drive(onCompleted: {
//            print("1")
//        })
//        self.vm.obLogin.flatMapCompletable { response in  }.catchError(self.rx.catchError)
        //错误转化为驱动,控制器直接驱动rx设置好的处理模式.如果要预先处理,那么先filter,最后绑定给全局处理
    }

    @IBAction func clickToast() {


//        Driver.just("1").drive(aaa)

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
