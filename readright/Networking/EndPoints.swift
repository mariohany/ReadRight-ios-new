//
//  ApiProvider.swift
//  readright
//
//  Created by concarsadmin-mh on 04/12/2021.
//

import Moya

enum Endpoint {
    case Login(email: String, password: String)
    case Register(email: String, password: String, confirmPassword: String, name: String, gender: Int, yearOfBirth: String, hemianopiaType:Int, vpSide:Int?, vpCause:Int?, vpStartDate:String?, vpExtraCause:String?)
    case ForgetPassword(email: String)
    case GetUserInfo
    case UpdateUserInfo(email: String, password: String, confirmPassword: String, name: String, gender: Int, yearOfBirth: String, hemianopiaType:Int, vpSide:Int?, vpCause:Int?, vpStartDate:String?, vpExtraCause:String?)
    case GetTherapyHistory(from:Int, to:Int)
    case GetReadingTestHistory
    case GetFieldTestHistory(from:Int, to:Int)
    case GetNeglectTestHistory
    case GetSearchTestHistory
    case GetBooks
    case GetChaptersByBook(bookId:Int)
}

extension Endpoint: TargetType {
    var baseURL: URL {
        return Constants.baseURL
    }
 
    var path: String {
        switch self {
        case .Login: return "login"
        case .Register: return "register"
        case .ForgetPassword: return "gateway/identity/account/sendSMS"
        case .GetUserInfo: return "user"
        case .UpdateUserInfo: return "user/info"
            
        case .GetTherapyHistory: return "users/GetTherapyHistory"
        case .GetReadingTestHistory: return "visualreading/history"
        case .GetFieldTestHistory: return "visualfield/hits/history"
        case .GetNeglectTestHistory: return "visualneglect/history"
        case .GetSearchTestHistory: return "users/GetSearchTestHistory"
        case .GetBooks: return "therapy/GetBooks"
        case .GetChaptersByBook: return "therapy/GetChaptersByBook"
        }
    }

    var method: Moya.Method {
        switch self {
        case .ForgetPassword, .GetUserInfo, .GetSearchTestHistory, .GetNeglectTestHistory, .GetReadingTestHistory, .GetTherapyHistory, .GetFieldTestHistory, .GetBooks, .GetChaptersByBook : return .get
        case .UpdateUserInfo : return .put
        case .Login, .Register : return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .Login(let email, let password):
            let params = ["email": email,
                          "password": password]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .Register(let email, let password, let confirmPassword, let name, let gender, let yearOfBirth, let hemianopiaType, let vpSide, let vpCause, let vpStartDate, let vpExtraCause):
            let params:[String : Any?] = ["email": email,
                          "password": password,
                          "password_confirm": confirmPassword,
                          "name" : name,
                          "gender": gender,
                          "yob": yearOfBirth,
                          "ha_type": hemianopiaType,
                          "vp_side": vpSide,
                          "vp_cause": vpCause,
                          "vp_start_date": vpStartDate,
                          "vp_extra_cause": vpExtraCause,
            ]
            return .requestParameters(parameters: params as [String : Any], encoding: JSONEncoding.default)
            
        case .ForgetPassword(let email):
            let params:[String : Any] = ["email": email]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case .GetUserInfo : return .requestPlain

        case .UpdateUserInfo(let email, let password, let confirmPassword, let name, let gender, let yearOfBirth, let hemianopiaType, let vpSide, let vpCause, let vpStartDate, let vpExtraCause):
            let params:[String : Any?] = ["email": email,
                                          "password": password,
                                          "password_confirm": confirmPassword,
                                          "name" : name,
                                          "gender": gender,
                                          "yob": yearOfBirth,
                                          "ha_type": hemianopiaType,
                                          "vp_side": vpSide,
                                          "vp_cause": vpCause,
                                          "vp_start_date": vpStartDate,
                                          "vp_extra_cause": vpExtraCause,
                            ]
            return .requestParameters(parameters: params as [String : Any], encoding: JSONEncoding.default)
        case .GetTherapyHistory(let from, let to):
            let params: [String : Any] = [ "From": from,
                           "To": to
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .GetReadingTestHistory:
            return .requestPlain
        case .GetFieldTestHistory(let from, let to):
            let params: [String : Any] = [ "From": from,
                           "To": to
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .GetNeglectTestHistory:
            return .requestPlain
        case .GetSearchTestHistory:
            return .requestPlain
        case .GetBooks:
            return .requestPlain
        case .GetChaptersByBook(let bookId):
            let params: [String : Any] = [
                "BookId": bookId
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
        
    var headers: [String : String]? {
        let token = SharedPref.shared.accessToken
        var header = [
//            "Accept-Language": SharedPreferences.shared.currentLang ?? "ar",
            "channel": "APP_IOS",
//            "mobile-version" : "\(Bundle.main.releaseVersionNumber ?? "")",
//            "correlation-id" : KeychainAccess.getUUID() ?? ""
        ]
        if let token = token{
            header["Authorization"] = "Bearer " + token
        }
        switch self {
//        case .Login:
//            header.updateValue("application/x-www-form-urlencoded", forKey: "Content-Type")
//            return header
        default:
            header.updateValue("application/json", forKey: "Content-Type")
            return header
        }
    }
}
