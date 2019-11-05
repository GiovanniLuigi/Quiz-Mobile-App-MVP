//
//  ViewController.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var wordTextField: UITextField! 
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWordsTableView()
    }
    
    // MARK: - Actions
    @IBAction func didTapStartButton(_ sender: Any) {
    }
    
    // MARK: - Private functions
    private func setupWordsTableView() {
        wordsTableView.dataSource = self
    }
}


// MARK: - WordsTableView
extension QuizViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
