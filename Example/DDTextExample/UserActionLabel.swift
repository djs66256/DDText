//
//  UserActionLabel.swift
//  DDTextExample
//
//  Created by daniel on 2021/9/25.
//  Copyright © 2021 daniel. All rights reserved.
//

import UIKit
import DDText

class UserActionLabelViewController: UIViewController {
    let label = DDLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        view.addSubview(label)
        
        let text = AttributedTextBuilder()
            .systemFont(ofSize: 17)
            .append(string: "This is a string with ")
            .save()
            .DDUserAction({ [weak self] (text) -> Void in
                let alert = UIAlertController(title: "\(text.string) is pressed!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { [weak alert] (_) in
                    alert?.dismiss(animated: true, completion: nil)
                }))
                self?.present(alert, animated: true, completion: nil)
            })
            .DDHighlightedBackgroundColor(.red)
            .textColor(.blue)
            .append(string: "USER ACTION")
            .restore()
            .append(string: ". Try to press the blue area.")
            .buildAttributedString()
        label.attributedText = text
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 10, y: 100, width: view.frame.width - 20, height: 200)
    }
}
