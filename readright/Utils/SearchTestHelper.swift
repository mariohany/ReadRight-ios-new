//
//  SearchTestHelper.swift
//  readright
//
//  Created by user225703 on 7/18/22.
//

import Foundation

class SearchTestHelper {
    
    static func getItemName(_ stringIndex:Int) -> String{
        let SEARCH_ITEMS_NAME:[String] = ["cup","red pencil" ,"green pencil" ,"red pen" ,"blue pen" , "Coin 1","Coin 2",  "candie" ,"binder" , "small key" ,"red pin","blue  pin" , "white pin" , "purple clip" ,"green clip" , "orange clip"]

        return SEARCH_ITEMS_NAME[stringIndex]
    }

}
