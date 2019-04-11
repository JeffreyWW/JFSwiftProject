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
    @IBOutlet weak var btnAgreement: UIButton!
    let disposeBag = DisposeBag()
    lazy var vm: JFHomeViewModel = {
        let phone = self.txtPhone.rx.text.orEmpty.asDriver()
        let password = self.txtPassword.rx.text.orEmpty.asDriver()
        let agreementTap = self.btnAgreement.rx.tap.asDriver()
        let nextTap = self.btnNext.rx.tap.asDriver()
        let confirm = self.confirm
        return JFHomeViewModel(input: (phone: phone, password: password, agreementTap: agreementTap, nextTap: nextTap, confirm: confirm))
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
        self.setupUI()
        self.asObserver()
    }

    private func setupUI() {
        Driver.just("协议未勾选").drive(self.btnAgreement.rx.title(for: .normal)).disposed(by: self.disposeBag)
        Driver.just("协议已勾选").drive(self.btnAgreement.rx.title(for: .selected)).disposed(by: self.disposeBag)
    }

    private func asObserver() {
        /**按钮选中监听*/
        self.vm.output.agreementSelected.drive(self.btnAgreement.rx.isSelected).disposed(by: self.disposeBag)
        /**按钮可用*/
        self.vm.output.btnEnable.drive(self.btnNext.rx.isEnabled).disposed(by: self.disposeBag)
        /**弹出确认提示,点确定才能继续请求,点击相当于是输入,needConfirm应该是传入一个监听器,内部继续监听,如果下一步又开始的话,那就
        在内部监听里继续进行请求*/
        self.vm.output.needConfirm.drive(self.confirmAlert).disposed(by: self.disposeBag)
        //所有内部数据校验的错误提示
        self.vm.output.showToast.drive(self.hud.rx.showMessage).disposed(by: self.disposeBag)
        //开始请求,去驱动转圈
        self.vm.output.startRequest.drive(self.hud.rx.loading).disposed(by: self.disposeBag)

        //去驱动隐藏,隐藏要的是另外一个监听者,这里返回弹信息监听者,并转换成Void
        self.vm.output.loginResult.asSuccess().drive(self.hud.rx.hidden.mapObserver { (r: JFApiResponse) in
            //这要的是Void类型,所以先写好Void类型,并返回当前map时候需要的类型值,即字符串
            return self.hud.rx.showMessage.mapObserver {
                return "登录成功"
            }
        }).disposed(by: self.disposeBag)

    }

    @IBAction func clickToast() {
    }

    @IBAction func clickHidden() {
        self.view.hideAllToasts()

    }
}
