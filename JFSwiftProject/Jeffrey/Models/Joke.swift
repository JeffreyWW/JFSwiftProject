//
// Created by Jeffrey on 2019-04-01.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import ObjectMapper
struct Joke: Mappable {
    var content: String?
    var hashId: String?
    var unixtime: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        content <- map["content"]
        hashId <- map["hashId"]
        unixtime <- map["unixtime"]
    }
}
