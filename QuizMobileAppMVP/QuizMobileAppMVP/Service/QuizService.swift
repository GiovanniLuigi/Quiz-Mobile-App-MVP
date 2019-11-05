//
//  QuizService.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import Foundation

class QuizService {
    
    private let fetchQuizEndpoint = "https://codechallenge.arctouch.com/quiz/1"
    
    func fetchQuiz(completionHandler: @escaping (Result<QuizModel, Error>) -> Void){
        guard let url = URL(string: fetchQuizEndpoint) else {
            print("error with the url")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300, let data = data {
                    
                    if let quiz: QuizModel = Parser.shared.decode(data: data) {
                        completionHandler(.success(quiz))
                    } else {
                        
                    }
                }
            }
        }
        task.resume()
    }
    
}
