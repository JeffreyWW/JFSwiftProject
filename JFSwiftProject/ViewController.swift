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

        Observable.merge(s1, s2).subscribe(onNext: { vc in
            self.navigationController!.pushViewController(vc, animated: true)
        })


        // Do any additional setup after loading the view, typically from a nib.
    }
}
