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
        /**声明给出了类型则在闭包里in前面可以忽略类型,闭包入参为Void类型,则可以直接忽略掉形参*/
        let oJeff: Observable<UIViewController> = self.btnJeff.rx.tap.map { JFMainController() }
        let oHY: Observable<UIViewController> = self.btnHY.rx.tap.map { HYController() }
        Observable.merge(oJeff, oHY).bind(to: self.navigationController!.rx.push).disposed(by: self.disposeBag)
        // Do any additional setup after loading the view, typically from a nib.
    }
}
