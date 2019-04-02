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


    @IBAction func clickToast() {
        let content = HUDContentType.labeledProgress(title: "", subtitle: "23234")
        PKHUD.sharedHUD
        HUD.flash(content, delay: 2)
//        let view = UIView()
//        let t: TimeInterval = TimeInterval()
//        view.backgroundColor = UIColor.black
//        let btn = UIButton()
//        let act = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        act.style = .whiteLarge
//        act.startAnimating()
//        view.addSubview(act)
//        self.view.showToast(view, duration: Double.infinity, position: .center) { b in
//        }
//        view.snp.makeConstraints { maker in
//            maker.height.width.equalTo(50)
//            maker.center.equalToSuperview()
//        }
    }

    @IBAction func clickHidden() {
        self.view.hideAllToasts()
    }
}
