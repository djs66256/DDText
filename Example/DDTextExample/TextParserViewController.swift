//
//  TextParserViewController.swift
//  DDTextExample
//
//  Created by daniel on 2021/9/25.
//  Copyright © 2021 daniel. All rights reserved.
//

import UIKit
import DDText

class MyEmojViewGenerator : EmojAttachmentGenerator {
    func generate(text: Substring) -> DDViewAttachment {
        return DDViewAttachment(viewCreator: { () -> UIView in
            let view = UIView()
            let emojLabel = UILabel()
            emojLabel.font = .systemFont(ofSize: 10)
            emojLabel.layer.cornerRadius = 8
            emojLabel.clipsToBounds = true
            emojLabel.backgroundColor = .green
            emojLabel.text = String(text)
            view.addSubview(emojLabel)
            emojLabel.frame = CGRect(x: 4, y: 0, width: 40, height: 16)
            return view
        }, viewSize: CGSize(width: 40 + 8, height: 16))
    }
}

class TextParserViewController: UIViewController {

    let label = DDLabel()
    let parsedLabel = DDLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        view.addSubview(label)
        
        parsedLabel.isUserInteractionEnabled = true
        parsedLabel.numberOfLines = 0
        view.addSubview(parsedLabel)

        let print = { [weak self] (_ text: NSAttributedString) in
            let alert = UIAlertController(title: "\(text.string) is pressed!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { [weak alert] (_) in
                alert?.dismiss(animated: true, completion: nil)
            }))
            self?.present(alert, animated: true, completion: nil)
        }
        
        let text = "Hello world, @Daniel . Welcome to my homepage \"https://github.com/djs66256\". My email adress is djs66256@163.com . #OpenSource# is the hotest topic today. [Good][Happy]"
        
        let builder = AttributedTextBuilder()
            .systemFont(ofSize: 15)
            .textColor(.black)
            .lineHeightMultiple(1.2)
        label.attributedText = builder.append(string: text).buildAttributedString()
        
        var config = CompositeTextParserConfiguration()
        config.defaultAttributes = builder.textColor(.black).buildAttributes()
        config.atUserAttributes = builder
            .textColor(.red)
            .DDHighlightedBackgroundColor(.lightGray)
            .DDUserAction({ (text) in
                print(text)
            }).buildAttributes()
        config.linkAttributes = builder
            .textColor(.blue)
            .DDHighlightedBackgroundColor(.lightGray)
            .DDUserAction({ (text) in
                print(text)
            }).buildAttributes()
        config.emailAttributes = builder
            .textColor(.brown)
            .DDHighlightedBackgroundColor(.lightGray)
            .DDUserAction({ (text) in
                print(text)
            }).buildAttributes()
        config.topicAttributes = builder
            .textColor(.orange)
            .DDHighlightedBackgroundColor(.lightGray)
            .DDUserAction({ (text) in
                print(text)
        }).buildAttributes()
        config.emojViewGenerator = MyEmojViewGenerator()
        
        let textParser = CompositeTextParser(config: config)
        
        textParser.parse(string: text) { (attributedText) in
            parsedLabel.attributedText = attributedText
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 10, y: 100, width: view.frame.width - 20, height: 200)
        parsedLabel.frame = CGRect(x: 10, y: 300, width: view.frame.width - 20, height: 200)
    }

}
