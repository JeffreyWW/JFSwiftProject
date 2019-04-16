//
// Created by Jeffrey on 2019-04-16.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import UIKit

class JFMainController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    private func setupUI() {
        self.navigationItem.title = "主页面"
        self.view.backgroundColor = UIColor.white
    }
}
