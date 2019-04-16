//
//  ViewController.swift
//  JFSwiftProject
//
//  Created by Jeffrey on 2019-03-28.
//  Copyright © 2019 CrfChina. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    //Jeff按钮
    @IBOutlet weak var btnJeff: UIButton!
    //黄宇按钮
    @IBOutlet weak var btnHY: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let s1 = self.btnJeff.rx.controlEvent(.touchUpInside).map { () -> UIViewController in
            JFController.init()
        }
        let s2 = self.btnHY.rx.controlEvent(.touchUpInside).map { () -> UIViewController in
            HYController.init()
        }
        let d1 = self.btnJeff.rx.tap.map { () -> UIViewController in
            JFMainController()
        }
        let d2 = self.btnHY.rx.tap.map { () -> UIViewController in
            HYController()
        }
        Observable.merge(d1, d2).subscribe(onNext: { vc in
            self.navigationController!.pushViewController(vc, animated: true)
        }).disposed(by: self.disposeBag)


        // Do any additional setup after loading the view, typically from a nib.
    }
}
