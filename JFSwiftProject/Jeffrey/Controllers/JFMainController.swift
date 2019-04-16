//
// Created by Jeffrey on 2019-04-16.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift
//import RxCocoa

let cellId = "cellId"

class JFMainController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    private func setupUI() {

        self.navigationItem.title = "主页面"
        self.view.backgroundColor = UIColor.white

//        self.tableView.register(UITableView.self, forCellReuseIdentifier: cellId)
//        RxTableViewSectionedReloadDataSource<SectionModel<String, Model>> { (source: TableViewSectionedDataSource<SectionModel>, view: UITableView, path: IndexPath, i: Model) in
//        }
    }
}

struct Model {

}

//class DataModel: SectionModelType {
//    private(set) var items: [Array] = []
//
//
//    required init(original: DataModel, items: [Array]) {
//
//    }
//}
