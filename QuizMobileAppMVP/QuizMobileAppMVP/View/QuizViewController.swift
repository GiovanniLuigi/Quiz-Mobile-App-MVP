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
    }
    
    // MARK: - Actions
    @IBAction func didTapStartButton(_ sender: Any) {
        LoadingOverlay.shared.showOverlay(in: view)
    }
    
    // MARK: - Private functions
    private func setupWordsTableView() {
        wordsTableView.dataSource = self
        wordsTableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func setupQuizViewModel() {
        viewModel.delegate = self
    }
    
    private func startActivityIndicator() {
        print("loading...")
    }
    
    private func stopActivityIndicator() {
        print("done...")
    }
    
    private func showErrorMessage() {
        print("error ocurred")
    }
}

// MARK: - WordsTableView
extension QuizViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.answer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: QuizCell.reuseIdentifier) as? QuizCell {
            cell.wordLabel.text = "static"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

// MARK: - QuizViewModel
extension QuizViewController: QuizViewModelDelegate {
    func didFinishNetworking() {
        DispatchQueue.main.async { [unowned self] in
            self.stopActivityIndicator()
        }
    }
    
    func didFetchQuiz() {
        DispatchQueue.main.async { [unowned self] in
            self.questionLabel.text = self.viewModel.question
            self.wordsTableView.reloadData()
        }
    }
    
    func errorToFetchQuiz() {
        DispatchQueue.main.async { [unowned self] in
            self.showErrorMessage()
        }
    }
    
}
