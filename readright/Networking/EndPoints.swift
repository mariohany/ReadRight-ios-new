//
//  ApiProvider.swift
//  readright
//
//  Created by concarsadmin-mh on 04/12/2021.
//

import Moya

enum Endpoint {
    case Login(email: String, password: String)
    case Register(email: String, password: String, confirmPassword: String, name: String, gender: String, yearOfBirth: String, hemianopiaType:Int, vpSide:Int?, vpCause:Int?, vpStartDate:String?, vpExtraCause:String?)
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
    
    case SubmitReadingTest(stage:Int, passage1:Int, passage2:Int, passage3:Int, answer1:Int, answer2:Int, answer3:Int, readingSpeed:Int, idPassage1:Int, idPassage2:Int, idPassage3:Int)
    case SubmitVisualFieldTest(model: NetworkModels.VisualFieldTestRequest)
    case SubmitADLTest(driving:Int, readingNews:Int, hygiene:Int, readingBooks:Int, enjoyReading:Int, findThings:Int)
    case SubmitSearchTest(model: NetworkModels.SearchTestRequest)//score:Int, duration:Float)
    case SubmitVisualNeglectTest(model:NetworkModels.VisualNeglectTestRequest)
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
            
        case .GetTherapyHistory: return "therapy"
        case .GetReadingTestHistory: return "visualreading/history"
        case .GetFieldTestHistory: return "visualfield/hits/history"
        case .GetNeglectTestHistory: return "visualneglect/history"
        case .GetSearchTestHistory: return "visualsearch"
        case .GetBooks: return "therapy-books"
        case .GetChaptersByBook(let bookId): return "therapy-books-chapter/\(bookId)"
            
        case .SubmitReadingTest: return "visualreading"
        case .SubmitVisualFieldTest: return "visualfield"
        case .SubmitADLTest: return "activities"
        case .SubmitSearchTest: return "visualsearch"
        case .SubmitVisualNeglectTest: return "visualneglect"
        }
    }

    var method: Moya.Method {
        switch self {
        case .ForgetPassword, .GetUserInfo, .GetSearchTestHistory, .GetNeglectTestHistory, .GetReadingTestHistory, .GetTherapyHistory, .GetFieldTestHistory, .GetBooks, .GetChaptersByBook : return .get
        case .UpdateUserInfo : return .put
        case .Login, .Register, .SubmitReadingTest, .SubmitVisualFieldTest, .SubmitADLTest, .SubmitSearchTest, .SubmitVisualNeglectTest : return .post
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
            var params:[String : Any?] = ["email": email,
                          "password": password,
                          "password_confirm": confirmPassword,
                          "name" : name,
                          "gender": gender,
                          "yob": yearOfBirth,
                          "ha_type": hemianopiaType,
                          "vp_side": vpSide,
                          "vp_cause": vpCause,
                          "vp_start_date": vpStartDate
            ]
            if let extraCause = vpExtraCause {
                params["vp_extra_cause"] = extraCause
            }
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
        case .GetChaptersByBook:
            return .requestPlain
        case .SubmitReadingTest(let stage, let passage1, let passage2, let passage3, let answer1, let answer2, let answer3, let readingSpeed, let idPassage1, let idPassage2, let idPassage3):
            let params:[String : Int?] = ["stage": stage,
                          "passage1": passage1,
                          "passage2": passage2,
                          "passage3": passage3,
                          "answer1": answer1,
                          "answer2": answer2,
                          "answer3": answer3,
                          "reading_speed": readingSpeed,
                          "passage1_id": idPassage1,
                          "passage2_id": idPassage2,
                          "passage3_id": idPassage3,
            ]
            return .requestParameters(parameters: params as [String : Any], encoding: JSONEncoding.default)
        case .SubmitVisualFieldTest(let model):
            return .requestParameters(parameters: model.dictionary!, encoding: JSONEncoding.default)
        case .SubmitADLTest(let driving, let readingNews, let hygiene, let readingBooks, let enjoyReading, let findThings):
            let params:[String : Any] = ["driving": driving,
                                        "reading_news": readingNews,
                                        "hygiene": hygiene,
                                        "reading_books": readingBooks,
                                        "enjoy_reading": enjoyReading,
                                        "find_things": findThings
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .SubmitSearchTest(let model):
            return .requestParameters(parameters: model.dictionary!, encoding: JSONEncoding.default)
        case .SubmitVisualNeglectTest(let model):
            return .requestParameters(parameters: model.dictionary!, encoding: JSONEncoding.default)
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
