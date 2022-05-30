//
//  NetworkingModel.swift
//  readright
//
//  Created by concarsadmin-mh on 31/12/2021.
//

import Foundation
import Moya

struct NetworkModels {
    
    struct LoginResponse: Codable {
        let id: Int?
        let name: String?
        let token: String?
    }
    
    public struct NetworkingError: Error {

        let httpResponse: HTTPURLResponse?
        let customModel: BaseErrorModel?
        let baseError: MoyaError

        init(_ response:Response) {
            self.baseError = MoyaError.statusCode(response)
            self.httpResponse = response.response
            self.customModel = try? JSONDecoder().decode(BaseErrorModel.self, from: response.data)
        }

        func getLocalizedDescription() -> String {
           return self.baseError.localizedDescription
        }
    }
    
    struct BaseErrorModel: Codable {
        let message: [String]?
    }
    
    struct UserInfo: Codable {
        let id: Int?
        let email,name,vpExtraCause,yob,vpStartDate: String?
        let gender,hemianopiaTypeId,vpSideId,vpCauseId,status,iteration,examinationId: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case email
            case name
            case gender
            case yob
            case status
            case iteration
            case examinationId
            case vpStartDate = "vp_start_date"
            case hemianopiaTypeId = "ha_type"
            case vpSideId = "vp_side"
            case vpCauseId = "vp_cause"
            case vpExtraCause = "vp_extra_cause"
        }
    }
    
    struct ResultsBaseModel: Codable {
        let TherapySpentTime: Int?
        let History: [HistoryItem]?
    }
    
    struct HistoryItem: Codable {
        let date,Title,TherapyTime: String?
        let ReactionTime, ReadingSpeed, Score: CGFloat?
        let NodeHits: [Int]?
    }
    
    struct BookDataItem: Codable {
        let bookTitle,bookAuthor,bookCategory: String?
        let bookId: Int?
    }
    
    struct ChapterDataItem: Codable {
        let chapterTitle,chapterUrl: String?
        let chapterId: Int?
    }
    
    struct Book: Codable {
        let bookId:Int?
        let title, author, genre: String?
        
        enum CodingKeys: String, CodingKey {
            case bookId = "BookId"
            case title = "Title"
            case author = "Author"
            case genre = "Genre"
        }
    }
    
    struct Chapter: Codable {
        let chapterId:Int?
        let title, url: String?
        
        enum CodingKeys: String, CodingKey {
            case chapterId = "ChapterId"
            case title = "Title"
            case url = "URL"
        }
    }
}
