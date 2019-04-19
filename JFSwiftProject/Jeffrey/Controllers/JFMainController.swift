//
// Created by Jeffrey on 2019-04-16.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift
import RxCocoa

let cellId = "cellId"

private enum JFSectionType: Int, SectionModelType {
    case first
    case second
    typealias Item = JFItemType
    var items: [JFItemType] {
        switch self {
        case .first:
            return [.login]
        case .second:
            return [.tableView, .collectionView]
        }
    }

    init(original: JFSectionType, items: [JFItemType]) {
        self = original
    }

    static var allSection: [JFSectionType] {
        return [.first, .second]
    }
}

private enum JFItemType: Int {
    case login
    case tableView
    case collectionView
}


class JFMainController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let dataSource: [JFSectionType] = JFSectionType.allSection
    lazy var staticCells: [UITableViewCell] = {
        let loginCell = UITableViewCell()
        loginCell.textLabel?.text = "登录"
        let tvbCell = UITableViewCell()
        tvbCell.textLabel!.text = "tableView"
        let cCell = UITableViewCell()
        cCell.textLabel!.text = "collectionView"
        return [loginCell, tvbCell, cCell]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    private func setupUI() {
        self.navigationItem.title = "主页面"
        self.view.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let configureCell: RxTableViewSectionedReloadDataSource<JFSectionType>.ConfigureCell = { source, tableView, indexPath, itemType in
            return self.staticCells[itemType.rawValue]
        }
        let dataSource = RxTableViewSectionedReloadDataSource(configureCell: configureCell)
        Driver<[JFSectionType]>.just(self.dataSource).drive(self.tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)

        self.tableView.rx.modelSelected(JFItemType.self).asDriver().drive(self.clickBinder).disposed(by: self.disposeBag)
    }
}

extension JFMainController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    private var clickBinder: Binder<JFItemType> {
        return Binder<JFItemType>(self) { (target: UIViewController, model: JFItemType) in
            switch model {
            case .login:
                print("进入登录页")
                break
            case .tableView:
                break
            case .collectionView:
                break
            }
        }
    }
}
