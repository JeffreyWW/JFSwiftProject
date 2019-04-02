//
// Created by Jeffrey on 2019-03-29.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper
import SwiftyJSON

class JFHomeViewModel {
    var jokes: [Joke] = []
    lazy var obGetRandJokes = {
        JFProviderManager.default.request(api: .getRandJokes).flatMapCompletable { response in
            let dic = response.result as? [String]
//            let a = JSON(<#T##object: Any##Any#>).dictionary
            print("")
//            self.jokes = Mapper<Joke>.init().mapArray(JS  ONObject: response.result)!
//            return Completable.error(JFError.system(error: .overTime))
            return Completable.empty()
        }
    }()
}
