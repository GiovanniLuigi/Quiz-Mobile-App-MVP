//
//  ViewController.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    // MARK: - Properties
    var viewModel = QuizViewModel(quizService: QuizService())
    
    // MARK: - Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField! 
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWordsTableView()
        setupQuizViewModel()
        self.hideKeyboardWhenTappedAround()
        wordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    // MARK: - Actions
    @IBAction func didTapStartButton(_ sender: Any) {
        viewModel.start()
    }
    
    // MARK: - Private functions
    private func setupWordsTableView() {
        wordsTableView.dataSource = self
        wordsTableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func setupQuizViewModel() {
        viewModel.delegate = self
        startActivityIndicator()
        viewModel.fetchQuiz()
    }
    
    private func startActivityIndicator() {
        LoadingOverlay.shared.showOverlay(in: view)
        toggleHiddenTopElements()
    }
    
    private func stopActivityIndicator() {
        LoadingOverlay.shared.hideOverlay()
        toggleHiddenTopElements()
    }
    
    private func toggleHiddenTopElements() {
        questionLabel.isHidden.toggle()
        wordTextField.isHidden.toggle()
        wordsTableView.isHidden.toggle()
    }
    
    private func showErrorMessage() {
        print("error ocurred")
    }
    
    @objc
    private func textFieldDidChange() {
        viewModel.checkForMatch(word: wordTextField.text ?? "")
    }
    
    private func restart() {
        
    }
}

// MARK: - WordsTableView
extension QuizViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: QuizCell.reuseIdentifier) as? QuizCell {
            let answer = viewModel.userAnswers[indexPath.row]
            cell.wordLabel.text = answer
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

// MARK: - QuizViewModel
extension QuizViewController: QuizViewModelDelegate {
    func updateTimer() {
        DispatchQueue.main.async { [unowned self] in
            self.timerLabel.text = self.viewModel.formattedTime
        }
    }
    
    func didScore() {
        DispatchQueue.main.async { [unowned self] in
            self.wordTextField.text = ""
            self.wordsTableView.reloadData()
        }
    }
    
    func didWin() {
        AlertHelper.showAlert(controller: self, title: "Congratulations", message: "Good job! You found all the answers on time. Keep up with the great work.", actionTitle: "Play again") { [unowned self] (_) in
            self.restart()
        }
    }
    
    func didLose() {
        let correctAnswerCount = viewModel.userAnswers.count
        let totalAnswerCount = viewModel.answer.count
        AlertHelper.showAlert(controller: self, title: "Time Finished", message: "Sorry, time is up! You got \(correctAnswerCount) out of \(totalAnswerCount) answers.", actionTitle: "Try again") { [unowned self] (_) in
            self.restart()
        }
    }
    
    func didFinishNetworking() {
        DispatchQueue.main.async { [unowned self] in
            self.stopActivityIndicator()
        }
    }
    
    func didFetchQuiz() {
        DispatchQueue.main.async { [unowned self] in
            self.questionLabel.text = self.viewModel.question
            self.wordsTableView.reloadData()
            self.scoreLabel.text = "0/\(self.viewModel.answer.count)"
        }
    }
    
    func errorToFetchQuiz() {
        DispatchQueue.main.async { [unowned self] in
            self.showErrorMessage()
        }
    }
    
}


