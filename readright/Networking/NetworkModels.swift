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
            self.customModel = try? JSONDecoder().decode(BaseErrorModel.self, from: Data(response.mapString().utf8))
        }

        func getLocalizedDescription() -> String {
            return self.customModel?.message?.joined(separator: "\n") ?? self.baseError.localizedDescription
        }
    }
    
    struct BaseErrorModel: Codable {
        let message: [String]?
    }
    
    struct UserInfo: Codable {
        let id: Int?
        let email,name,vpExtraCause,yob,vpStartDate: String?
        let gender,hemianopiaTypeId,vpSideId,vpCauseId,status,iteration,examinationId,therapyTotalDuration: Int?
        var therapyCurrentDuration:Int
        var readingTestQuestionsCount:Int? = 0
        var readingTestAskedQuestions:[Int]? = []
        
        enum CodingKeys: String, CodingKey {
            case id
            case email
            case name
            case gender
            case yob
            case status
            case iteration
            case examinationId
            case readingTestQuestionsCount
            case readingTestAskedQuestions
            case vpStartDate = "vp_start_date"
            case hemianopiaTypeId = "ha_type"
            case vpSideId = "vp_side"
            case vpCauseId = "vp_cause"
            case vpExtraCause = "vp_extra_cause"
            case therapyCurrentDuration = "therapy_current_duration"
            case therapyTotalDuration = "therapy_total_duration"
        }
    }
    
    struct SubmitTherapyResponse: Codable {
        let remains: Int?
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
    
    struct SearchTestHistory: Codable {
        let date:String?
        let reactionTime: Double?
        
        enum CodingKeys: String, CodingKey {
            case date = "Test_date"
            case reactionTime = "Reaction_time"
        }
    }
    
    struct Book: Codable {
        let bookId:Int?
        let title, author, genre: String?
        
        enum CodingKeys: String, CodingKey {
            case bookId = "id"
            case title = "title"
            case author = "author"
            case genre = "genre"
        }
    }
    
    struct Chapter: Codable {
        let chapterId,bookId:Int?
        let title, url: String?
        
        enum CodingKeys: String, CodingKey {
            case chapterId = "id"
            case bookId = "bookId"
            case title = "title"
            case url = "url"
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
    
    struct ReadingRequestModel {
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
        var itemId, type, numClicks:Int?
        var x, y :Float?
        
        
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
    
    struct ReadingResults: Codable {
        let readingSpeed:Int?
        let createdAt:String?
        
        enum CodingKeys: String, CodingKey {
            case readingSpeed = "reading_speed"
            case createdAt = "created_at"
        }
    }
}
