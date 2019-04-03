//
// Created by Jeffrey on 2019-04-04.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation

enum JFLocalError: Error {
    case `default`(tag: Int)
    case alert(message: String)
    case toast(message: String)
    case confirm(message: String)
}
