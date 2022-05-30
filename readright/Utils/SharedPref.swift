//
//  SharedPref.swift
//  readright
//
//  Created by concarsadmin-mh on 19/01/2022.
//

import Foundation



class SharedPref {
    static let shared = SharedPref()
    
    
    func removeUserInfo(){
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "userInfo")
    }
    
    func setToken(token: String?){
        UserDefaults.standard.set(token, forKey: "accessToken")
        UserDefaults.standard.synchronize()
    }
    
    func setUserInfo(userInfo: NetworkModels.UserInfo?){
        let encodedData = try? JSONEncoder().encode(userInfo)
        UserDefaults.standard.set(encodedData, forKey: "userInfo")
        UserDefaults.standard.synchronize()
    }
    
    
    var accessToken: String? {
        let token = UserDefaults.standard.string(forKey: "accessToken")
        return token.flatMap({$0})
    }
    
    var userInfo: NetworkModels.UserInfo? {
        let decoded  = UserDefaults.standard.data(forKey: "userInfo") ?? Data()
        let model = try? JSONDecoder().decode(NetworkModels.UserInfo.self, from: decoded)
        return model
    }
    
}
