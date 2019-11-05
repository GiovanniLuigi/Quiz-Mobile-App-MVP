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
    func updateTimer()
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
    
    var timeInSeconds: TimeInterval = 300
    
    var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]

        return formatter.string(from: timeInSeconds) ?? String.empty
    }
    
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
        if answer.contains(word), !userAnswers.contains(word) {
            userAnswers.append(word)
            delegate?.didScore()
            if isWinner() {
                delegate?.didWin()
            }
        }
    }
    
    func reset() {
        delegate?.updateTimer()
    }
    
    func start() {
        delegate?.updateTimer()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] (timer) in
            self.timeInSeconds -= 1
            self.delegate?.updateTimer()
            if self.timeInSeconds <= 0 {
                timer.invalidate()
                self.delegate?.didLose()
            }
        }
    }
    
    private func isWinner() -> Bool {
        return answer.isEmpty
    }
    
}
