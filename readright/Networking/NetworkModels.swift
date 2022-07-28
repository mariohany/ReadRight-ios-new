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
    
    struct ReadingQuesionModel: Codable {
        let numberOfWords, answer:Int
        let storyText, questionText: String
        
        enum CodingKeys: String, CodingKey {
            case storyText = "StoryText"
            case questionText = "QuestionText"
            case numberOfWords = "NumberOfWords"
            case answer
        }
    }
    
    struct ReadingResultModel {
        let answer, questionNo:Int?
        let readingTime: Float?
    }
    
    struct SubmitTestsBaseResponse: Codable {
        let success:Bool?
        let message:String?
        
        enum CodingKeys: String, CodingKey {
            case success = "Success"
            case message = "Message"
        }
    }
    
    struct VisualFieldTestRequest: Codable {
        let duration:Float
        let nodesAnswers:[NodesAnswer]
        let nodesHits:[NodesHits]
        
        enum CodingKeys: String, CodingKey {
            case duration = "Duration"
            case nodesAnswers = "NodesAnswers"
            case nodesHits = "NodesHits"
        }
    }
    
    struct NodesAnswer: Codable {
        let question, nodeNo, answer:Int
        
        enum CodingKeys: String, CodingKey {
            case question = "Question"
            case nodeNo = "NodeNo"
            case answer = "Answer"
        }
    }

    struct NodesHits: Codable {
        let dot, shown, hit:Int
        
        enum CodingKeys: String, CodingKey {
            case dot = "Dot"
            case shown = "Shown"
            case hit = "Hit"
        }
    }
    
    struct Elements: Codable {
        let itemId, x, y, type, numClicks:Int
        
        enum CodingKeys: String, CodingKey {
            case itemId = "item_id"
            case x
            case y
            case type = "type"
            case numClicks = "num_clicks"
        }
    }
    
    struct HitsPath: Codable {
        let itemId, index:Int
        
        enum CodingKeys: String, CodingKey {
            case itemId = "item_id"
            case index
        }
    }
}
