//
// Created by Jeffrey on 2019-03-29.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

class JFHomeViewModel {
    var jokes: [Joke] = []
    lazy var obGetRandJokes = {
        JFProviderManager.default.request(api: .getRandJokes).flatMapCompletable { response in
            self.jokes = Mapper<Joke>.init().mapArray(JSONObject: response.result)!
//            return Completable.error(JFError.system(error: .overTime))
            return Completable.empty()
        }
    }()
}
