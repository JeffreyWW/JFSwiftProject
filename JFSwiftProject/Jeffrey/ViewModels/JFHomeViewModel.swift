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
    var jokes: [Joke]? = []
    lazy var obGetRandJokes = {
        JFProviderManager.default.request(api: .getRandJokes).flatMapCompletable { response in
            self.jokes = Mapper<Joke>().mapArray(JSONObject: response.result)
            return Completable.empty()
        }
    }()
    lazy var obHome = {
        JFProviderManager.default.request(api: .login(phone: "", password: "")).flatMapCompletable { response in
            print("")
            return Completable.empty()
        }
    }()
}
