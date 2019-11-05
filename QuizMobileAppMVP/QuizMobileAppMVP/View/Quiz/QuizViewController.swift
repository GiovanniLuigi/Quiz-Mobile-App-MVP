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
    @IBOutlet weak var bottomButton: QuizBottomButton!
    @IBOutlet weak var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var topStackView: UIStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWordsTableView()
        setupQuizViewModel()
        setupKeyboard()
        overrideUserInterfaceStyle = .light
    }
    
    @objc func keyboard(notification: Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
            self.bottomContainerConstraint.constant = keyboardReact.height
        }else{
            self.bottomContainerConstraint.constant = 0
        }
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @IBAction func didTapStartButton(_ sender: Any) {
        if viewModel.gameStarted {
            reset()
            bottomButton.setTitle("Start", for: .normal)
        } else {
            viewModel.start()
            bottomButton.setTitle("Reset", for: .normal)
        }
    }
    
    // MARK: - Private functions
    private func setupKeyboard() {
        self.hideKeyboardWhenTappedAround(view: topStackView)
        wordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [unowned self] in
            LoadingOverlay.shared.hideOverlay()
            self.toggleHiddenTopElements()
        }
    }
    
    private func toggleHiddenTopElements() {
        questionLabel.isHidden.toggle()
        wordTextField.isHidden.toggle()
        wordsTableView.isHidden.toggle()
    }
    
    private func showErrorMessage() {
        let errorMessage = viewModel.errorMessage
        AlertHelper.showAlert(controller: self, title: "Error", message: errorMessage, actionTitle: "Retry") { [unowned self] (_) in
            self.reset()
        }
    }
    
    @objc
    private func textFieldDidChange() {
        viewModel.checkForMatch(word: wordTextField.text ?? String.empty)
    }
    
    private func reset() {
        viewModel.reset()
        setupQuizViewModel()
        bottomButton.setTitle("Start", for: .normal)
    }
    
    private func updateScoreLabel() {
        self.scoreLabel.text = "\(self.viewModel.userAnswers.count)/\(self.viewModel.answer.count)"
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
    
    func updateScore() {
        DispatchQueue.main.async { [unowned self] in
            self.wordTextField.text = ""
            self.wordsTableView.reloadData()
            self.updateScoreLabel()
        }
    }
    
    func didWin() {
        AlertHelper.showAlert(controller: self, title: "Congratulations", message: "Good job! You found all the answers on time. Keep up with the great work.", actionTitle: "Play again") { [unowned self] (_) in
            self.reset()
        }
    }
    
    func didLose() {
        let correctAnswerCount = viewModel.userAnswers.count
        let totalAnswerCount = viewModel.answer.count
        AlertHelper.showAlert(controller: self, title: "Time Finished", message: "Sorry, time is up! You got \(correctAnswerCount) out of \(totalAnswerCount) answers.", actionTitle: "Try again") { [unowned self] (_) in
            self.reset()
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
            self.updateScoreLabel()
        }
    }
    
    func errorToFetchQuiz() {
        DispatchQueue.main.async { [unowned self] in
            self.showErrorMessage()
        }
    }
    
}


