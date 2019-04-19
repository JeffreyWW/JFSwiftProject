//
// Created by Jeffrey on 2019-04-17.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import RxDataSources


enum MainSectionModel: Int {
    case first
    case second
}

extension MainSectionModel: SectionModelType {
    typealias Item = ItemModel
    var items: [ItemModel] {
        get {
            return [.login]
        }
    }

    init(original: MainSectionModel, items: [ItemModel]) {
        self = original
    }
}


enum ItemModel {
    case login
    case tableView
}

