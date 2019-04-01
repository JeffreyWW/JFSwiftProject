//
//  JFController.swift
//  JFSwiftProject
//
//  Created by Jeffrey on 2019/3/28.
//  Copyright © 2019年 CrfChina. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import SwiftyJSON
import ObjectMapper

enum ErrorType: Int {
    case first = 10001
}


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

struct Model: Mappable {
    var errorCode: ErrorType?
    var reason: String?
    var result: AnyObject?
//    var result: Array<Dictionary<String, AnyObject>>?
    var resultCode: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        let intTransform = TransformOf<Int, String>(fromJSON: { s in
            if let intValue = Int(s!) {
                return intValue
            }
            return nil
        }, toJSON: { i in return nil })
        reason <- map["reason"]
        errorCode <- map["error_code"]
        result <- map["result"]
        resultCode <- (map["resultcode"], intTransform)

    }
}


class JFController: UIViewController {
    let vm = JFHomeViewModel.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let res = JFApiResponse()
        self.navigationItem.title = "Jeffrey"
        let provider = MoyaProvider<JFApi>()
        let ob = provider.rx.request(.home)
        self.vm.obHome.subscribe(onNext: { value in
            let model = Model(JSONString: value)
            let modelArray = Mapper<Joke>().mapArray(JSONObject: model?.result)
            print("")
        }, onError: { error in
            print(error)
        })
    }
}
