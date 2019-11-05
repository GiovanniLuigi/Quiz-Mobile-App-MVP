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
    func updateScore()
    func updateTimer()
}

class QuizViewModel {
    
    private let quizService: QuizService
    private var quizModel: QuizModel
    private var error: QuizError?
    
    var errorMessage: String {
        let message = "Sorry for the inconvenience... we had a "
        switch error {
        case .networkError:
            return message+"network error."
        case .parsingError:
            return message+"data parsing error."
        default:
            return message+"error."
        }
    }
    
    var delegate: QuizViewModelDelegate?
    
    var gameStarted: Bool = false
    
    var answer: [String] {
        return quizModel.answer
    }
    
    var question: String {
        return quizModel.question
    }
    
    var userAnswers: [String] = []
    
    let totalTimeInSeconds: TimeInterval = 300
    
    lazy var currentTimeInSeconds: TimeInterval = totalTimeInSeconds
    
    var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        return formatter.string(from: currentTimeInSeconds) ?? String.empty
    }
    
    private var timer: Timer?
    
    init(quizService: QuizService, delegate: QuizViewModelDelegate? = nil) {
        self.quizService = quizService
        self.delegate = delegate
        quizModel = QuizModel(question: String.empty, answer: [])
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
        if !gameStarted {return}
        if answer.contains(word), !userAnswers.contains(word) {
            userAnswers.append(word)
            delegate?.updateScore()
            if isWinner() {
                timer?.invalidate()
                delegate?.didWin()
            }
        }
    }
    
    func reset() {
        error = nil
        gameStarted = false
        timer?.invalidate()
        currentTimeInSeconds = totalTimeInSeconds
        quizModel = QuizModel(question: String.empty, answer: [])
        userAnswers = []
        
        delegate?.updateTimer()
    }
    
    func start() {
        gameStarted = true
        delegate?.updateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] (timer) in
            self.currentTimeInSeconds -= 1
            self.delegate?.updateTimer()
            if self.currentTimeInSeconds <= 0 {
                timer.invalidate()
                self.delegate?.didLose()
            }
        }
    }
    
    private func isWinner() -> Bool {
        return userAnswers.count == answer.count
    }
    
}
