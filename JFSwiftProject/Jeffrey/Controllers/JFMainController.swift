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

extension ItemModel {
    var cell: UITableViewCell {
        return UITableViewCell()
    }
}

struct JFSectionModel: SectionModelType {
    typealias Item = JFItemModel
    private(set) var items: [JFItemModel] = []

    init(original: JFSectionModel, items: [JFItemModel]) {
    }
}

struct JFItemModel {
    let type: CustomType

    enum CustomType {
        case login
        case tableView
    }

    init(type: CustomType) {
        self.type = type
    }
}

private enum SectionType: SectionModelType {
    case first
    case second
    var items: [ItemType] {
        switch self {
        case .first:
            return [.login]
        case .second:
            return [.tableView, .collectionView]
        }
    }

    init(original: SectionType, items: [ItemType]) {
        self = original
    }

    typealias Item = ItemType
    static var allSectionTypes: [SectionType] {
        return [.first, .second]
    }
}


private enum ItemType: Int {
    case login
    case tableView
    case collectionView
    var cell: UITableViewCell {
        return UITableViewCell()
    }
}


private extension JFMainController {
    func cellForItem(itemType: ItemType) -> UITableViewCell {

    }
}


class JFMainController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var loginCell: UITableViewCell = {
        let  a =
        /**可直接return一个枚举cell即可*/
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel!.text = "login"
        return cell
    }()
    lazy var tvbCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel!.text = "tableView"
        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    private func setupUI() {
        self.navigationItem.title = "主页面"
        self.view.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let aaa: MainSectionModel = MainSectionModel.first


        /**先设置好各个cell,然后通过某个方法返回指定的cell即可*/

//        let item = ItemType.login(cell: cellLogin, vc: self)
        /**直接枚举值传入要带出去的参数即可,不用搞那么复杂*/
        /**n个cell数组,cellforrow根据sectionType的枚举值拿到不同的数组,再根据rowtype的枚举值找到对应的cell*/

        /**用系统的SectionModel,section和item都为数字类型枚举,从0开始,返回cell的时候,可直接从根据item枚举值合作和indepath.row直接返回设置好的cell
        点击事件,item有一个传入控制器并返回binder的函数,直接用它即可*/

        /**枚举值都带控制器,item可以返回cell,根据枚举值和控制来返回,所以这些值肯定是固定的,点击事件则直接可以在里面写好*/


        let configureCell: RxTableViewSectionedReloadDataSource<SectionType>.ConfigureCell = { source, tableView, indexPath, i in
            let a = source.sectionModels[indexPath.row]
            let mainModel = source.sectionModels[indexPath.section]

            /**section是可以直接通过下标获取数组的*/
            /**这里根据model枚举具体的值来判断是否需要直接return一个静态单元格,一般如果显示的数据需要用在逻辑上,那么就需要是静态的,否则则可以返回一个重用的单元格
            ,也可以在之前建好cell,这里根据path直接返回cell,*/
            /**枚举里先设置好要显示的文字什么的,这里会直接显示单元格,根据下标,返回已经设置好的单元格,之前驱动已经给到了vm,这里只负责返回cell,下标肯定是对应了次级枚举
            所以点击事件可以直接返回binder,
            */
            /**根据枚举int值找cell即可*/
            return cell
        }

        let dataSource = RxTableViewSectionedReloadDataSource(configureCell: configureCell)
        Driver<[MainSectionModel]>.just([.first]).drive(self.tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
        self.tableView.rx.modelSelected(ItemModel.self).asDriver().drive(self.clickBinder).disposed(by: self.disposeBag)
    }
}

extension JFMainController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    private var clickBinder: Binder<ItemModel> {
        return Binder<ItemModel>(self) { (target: UIViewController, model: ItemModel) in
            switch model {
            case .login:
                print("进入登录页")
                break
            case .tableView:
                break
            }
        }
    }
}
