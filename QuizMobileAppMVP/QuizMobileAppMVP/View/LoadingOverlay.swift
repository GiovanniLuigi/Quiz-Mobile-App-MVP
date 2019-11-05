//
//  LoadingOverlay.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import UIKit

class LoadingOverlay {
    
    static let shared = LoadingOverlay()
    private let container: UIView = UIView()
    private init() {}
    
    func showOverlay(in view: UIView) {
        container.isHidden = false
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 130, height: 110)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0);
        actInd.style = .large
        actInd.color = .white
                    
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        
        let str = UILabel()
        str.text = "Loading..."
        str.font = UIFont(name: "SFProDisplay-Semibold", size: 17)
        str.textColor = .white
        str.sizeToFit()
        
        
        let stackView = UIStackView()
        loadingView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: loadingView.widthAnchor, multiplier: 0.8).isActive = true
        stackView.heightAnchor.constraint(equalTo: loadingView.heightAnchor, multiplier: 0.8).isActive = true
        
        stackView.axis = .vertical
        stackView.alignment = UIStackView.Alignment.center
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(actInd)
        stackView.addArrangedSubview(str)
        
        
        container.addSubview(loadingView)
        view.addSubview(container)
        actInd.startAnimating()
    }
    
    func hideOverlay() {
        container.isHidden = true
    }
    
}
