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
        let email,name,vpExtraCause,yob,vpStartDate,gender: String?
        let hemianopiaTypeId,vpSideId,vpCauseId,status,iteration,examinationId,therapyTotalDuration: Int?
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
        
        enum CodingKeys: String, CodingKey {
            case TherapySpentTime = "therapy_spent_time"
            case History = "history"
        }
    }
    
    struct NeglectResultItem:Codable {
        let score: Float?
        let date: String?
        
        enum CodingKeys: String, CodingKey {
            case score
            case date = "created_at"
        }
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
        let message:[String]?
        
        enum CodingKeys: String, CodingKey {
            case message = "message"
        }
    }
    
    struct VisualFieldTestRequest: Codable {
        let duration:Float
        let nodesAnswers:Array<NodesAnswer>
        let nodesHits:Array<NodesHits>
        
        enum CodingKeys: String, CodingKey {
            case duration = "duration"
            case nodesAnswers = "node_answers"
            case nodesHits = "node_hits"
        }
    }
    
    struct NodesAnswer: Codable {
        let question, nodeNo, answer:Int
        
        enum CodingKeys: String, CodingKey {
            case question = "question"
            case nodeNo = "node_number"
            case answer = "answer"
        }
    }

    struct NodesHits: Codable {
        let dot, shown, hit:Int
        
        enum CodingKeys: String, CodingKey {
            case dot = "dot"
            case shown = "shown"
            case hit = "hit"
        }
    }
    
    struct VisualNeglectTestRequest: Codable {
        let score,duration,targets,distractors, revisits, x, y, numTotalTargets, numTotalDistractors, numTargetsMissed, numTargetsMissedLeft, numTargetsMissedRight, numRevisits, numRevisitsLeft, numRevisitsRight, meanXTargets, meanYTargets:Int
        let elements:Array<Elements>
        let hitsPath:Array<HitsPath>
        
        enum CodingKeys: String, CodingKey {
            case score
            case duration
            case targets
            case distractors
            case revisits
            case x
            case y
            case numTotalTargets = "num_total_targets"
            case numTotalDistractors = "num_total_distractors"
            case numTargetsMissed = "num_total_missed"
            case numTargetsMissedLeft = "num_total_missed_l"
            case numTargetsMissedRight = "num_total_missed_r"
            case numRevisits = "num_revisits"
            case numRevisitsLeft = "num_revisits_l"
            case numRevisitsRight = "num_revisits_r"
            case meanXTargets = "mean_x_targets"
            case meanYTargets = "mean_y_targets"
            case elements
            case hitsPath = "hits_path"
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
    
    struct SearchTestRequest: Codable {
        let score:Int
        let duration:Double
        let q0_side,q1_side,q2_side,q3_side,q4_side,q5_side,q6_side,q7_side,q8_side,q9_side,q10_side,q11_side,q12_side,q13_side,q14_side,q15_side,q16_side:String
        let q0_rt,q1_rt,q2_rt,q3_rt,q4_rt,q5_rt,q6_rt,q7_rt,q8_rt,q9_rt,q10_rt,q11_rt,q12_rt,q13_rt,q14_rt,q15_rt,q16_rt:Double
        
        enum CodingKeys: String, CodingKey {
            case score
            case duration
            case q0_side
            case q1_side
            case q2_side
            case q3_side
            case q4_side
            case q5_side
            case q6_side
            case q7_side
            case q8_side
            case q9_side
            case q10_side
            case q11_side
            case q12_side
            case q13_side
            case q14_side
            case q15_side
            case q16_side
            case q0_rt
            case q1_rt
            case q2_rt
            case q3_rt
            case q4_rt
            case q5_rt
            case q6_rt
            case q7_rt
            case q8_rt
            case q9_rt
            case q10_rt
            case q11_rt
            case q12_rt
            case q13_rt
            case q14_rt
            case q15_rt
            case q16_rt
            
        }
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
