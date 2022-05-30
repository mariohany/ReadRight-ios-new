//
//  ApiProvider.swift
//  readright
//
//  Created by concarsadmin-mh on 04/12/2021.
//

import Moya
import RxSwift
import CommonCrypto
import Alamofire

let provider = CustomMoyaProvider<Endpoint>(plugins: [NetworkLoggerPlugin()])

final class CustomMoyaProvider<Target> where Target: Moya.TargetType {
    
    let provider: MoyaProvider<Endpoint>
    
    init(plugins: [PluginType]) {
        provider = MoyaProvider<Endpoint>(session: DefaultAlamofireSession.shared, plugins: [NetworkLoggerPlugin()])
    }

    func request(_ endpoint: Endpoint) -> Single<Moya.Response> {
        guard NetworkReachabilityManager()?.isReachable ?? false else {
            Helpers.handleErrorMessages(message: "No internet connection !")
            return Single.just(Moya.Response(statusCode: 0, data: Data()))
        }
        let request = provider.rx.request(endpoint)
            return request
                .flatMap { response in
                    if 200 ... 299 ~= response.statusCode {
                        return Single.just(response)
                    } else {
                        let netError = NetworkModels.NetworkingError(response)
                        return Single.error(netError)
                    }
                }
                .filterSuccessfulStatusCodes()
    }
}

//MARK:- APIs Timeout

class DefaultAlamofireSession: Alamofire.Session {
    static let shared: DefaultAlamofireSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 300
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return DefaultAlamofireSession(configuration: configuration)
    }()
}

//extension ObservableType where E == Response {
//  func filterSuccess() -> Observable<E> {
//    return flatMap { (response) -> Observable<E> in
//        if 200 ... 299 ~= response.statusCode {
//            return Observable.just(response)
//        }
//
//        if let errorJson = response.data.toJson(),
//           let error = Mapper<MyCustomErrorModel>().map(errorJson) {
//            return Observable.error(error)
//        }
//
//        // Its an error and can't decode error details from server, push generic message
//        let genericError = MyCustomErrorModel.genericError(code: response.statusCode, message: "Unknown Error")
//        return Observable.error(genericError)
//    }
//}
