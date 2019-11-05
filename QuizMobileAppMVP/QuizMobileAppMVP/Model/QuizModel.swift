//
//  QuizModel.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import Foundation

struct QuizModel: Codable {
    let question: String
    let answer: [String]
}
