//
//  QuizViewModel.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import Foundation

protocol QuizViewModelDelegate: class {
    func didFinishNetworking()
    func didFetchQuiz()
    func errorToFetchQuiz()
    func didWin()
    func didLose()
    func didScore()
}

class QuizViewModel {
    
    private let quizService: QuizService
    private var quizModel: QuizModel
    private var error: Error?
    
    var delegate: QuizViewModelDelegate?
    
    var answer: [String] {
        return quizModel.answer
    }
    
    var question: String {
        return quizModel.question
    }
    
    var userAnswers: [String] = []
    
    init(quizService: QuizService, delegate: QuizViewModelDelegate? = nil) {
        self.quizService = quizService
        self.delegate = delegate
        quizModel = QuizModel(question: "", answer: [])
    }
    
    func fetchQuiz() {
        quizService.fetchQuiz { [weak self] (result) in
            self?.delegate?.didFinishNetworking()
            switch result {
            case .success(let quiz):
                self?.quizModel = quiz
                self?.delegate?.didFetchQuiz()
            case .failure(let error):
                self?.error = error
                self?.delegate?.errorToFetchQuiz()
            }
        }
    }
    
    func checkForMatch(word: String) {
        if let index = answer.firstIndex(of: word) {
            quizModel.answer.remove(at: index)
            userAnswers.append(word)
            delegate?.didScore()
            if isWinner() {
                delegate?.didWin()
            }
        }
    }
    
    func reset() {
        
    }
    
    func start() {
        
    }
    
    private func isWinner() -> Bool {
        return answer.isEmpty
    }
    
}
