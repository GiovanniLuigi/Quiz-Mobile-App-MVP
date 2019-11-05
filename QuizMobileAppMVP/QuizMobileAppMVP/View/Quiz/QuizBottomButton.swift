//
//  QuizBottomButton.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import UIKit

class QuizBottomButton: UIButton {
    
    private let cornerRadius: CGFloat = 8
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.cornerRadius = cornerRadius
    }
    
}
