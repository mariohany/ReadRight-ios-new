//
//  Constants.swift
//  readright
//
//  Created by concarsadmin-mh on 08/12/2021.
//

import UIKit

public struct Constants {
    
//    static let baseURL:URL = URL(string: "https://arabic-readright.com")!
    static let baseURL:URL = URL(string: "http://188.166.23.205:3000/api/v1/")!
    static let TOUR_SLIDES:Int = 29
    static let TOUR_VOICE_OVER_ARRAY:[String] = ["tour1.mp3","tour2.mp3","tour3.mp3","tour4.mp3","tour5.mp3","tour6.mp3","tour7.mp3","tour8.mp3","tour9.mp3","tour10.mp3","tour11.mp3","tour12.mp3","tour13.mp3","tour14.mp3","tour15.mp3","tour16.mp3","tour17.mp3","tour18.mp3","tour19.mp3","tour20.mp3","tour21.mp3","tour22.mp3","tour23.mp3","tour24.mp3","tour25.mp3","tour26.mp3","tour27.mp3","tour28.mp3","tour29.mp3","tour30.mp3"]
    static let HISTORY_EMPTY = "لا يوجد نتائج!"
    	


    static let TESTS_INTRO_VOICE_OVER = "testsIntro.mp3"

    static let PREPARE_READING_VOICE_OVER = "prepareReading.mp3"
    static let INSTRUCTIONS_READING_VOICE_OVER = "instructionReading.mp3"
    static let HAVING_READING_VOICE_OVER = "havingReading.mp3"
    static let READING_QUESTIONS_VOICE_OVER_ARRAY:[String] = ["readingQ1.mp3","readingQ2.mp3","readingQ3.mp3","readingQ4.mp3","readingQ5.mp3","readingQ6.mp3","readingQ7.mp3","readingQ8.mp3","readingQ9.mp3","readingQ10.mp3","readingQ11.mp3","readingQ12.mp3"]


    static let PREPARE_VISUAL_VOICE_OVER = "prepareVisualField.mp3"
    static let INSTRUCTIONS_VISUAL_VOICE_OVER_ARRAY = ["instructionsVisualField1.mp3","instructionsVisualField2.mp3","instructionsVisualField3.mp3"]

    static let PREPARE_SEARCH_VOICE_OVER = "prepareSearch.mp3"
    static let INSTRUCTIONS_SEARCH_VOICE_OVER = "instructionsSearch.mp3"

    static let PREPARE_ADL_VOICE_OVER = "prepareADL.mp3"
    static let INSTRUCTIONS_ADL_VOICE_OVER = "instructionsADL.mp3"

    static let PREPARE_NEGLECT_VOICE_OVER = "prepareNeglect.mp3"
    static let INSTRUCTIONS_NEGLECT_VOICE_OVER = "instructionsNeglect.mp3"
    
    static let NUMBER_OF_CIRCLES = 4
    static let NUMBER_OF_DOTES_IN_CIRCLE = 4
    
    static let THERAPY_NEWS_VIEW = 0
    static let THERAPY_LIBRARY_VIEW = 1
    static let THERAPY_SHOULD_TIME = 18000
    
    static let RSS_FEEDS_URL = "https://arabic.cnn.com/rss"
    
    static let NUMBER_OF_TESTS = 6

    static let NEED_TESTS = 1
    static let NEED_THERAPY = 2

    static let READING_TEST1 = 1
    static let VISUAL_FIELD_TEST = 2
    static let READING_TEST2 = 3
    static let NEGLECT_TEST = 4
    static let ADL_TEST = 5
    static let SEARCH_TASK_TEST = 6

    static let NUMBER_NEGLECT_DISTRACTORS = 36
    static let NUMBER_NEGLECT_TARGETS = 15


    static let NUMBER_OF_VISUAL_FIELD_QUESTIONS = 36
    static let NUMBER_OF_VISIUAL_FIELD_DOTS = 16


    static let NUMBER_OF_VISIUAL_SEARCH_TRIALS = 17
    
}
