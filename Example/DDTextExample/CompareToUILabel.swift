//
//  CompareToUILabel.swift
//  DDTextExample
//
//  Created by daniel on 2021/9/25.
//  Copyright © 2021 daniel. All rights reserved.
//

import UIKit
import DDText

class MyLabelTableCell: UITableViewCell {
    let label1 = DDLabel()
    let label2 = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label1.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        contentView.addSubview(label1)
        
        label2.backgroundColor = UIColor.green.withAlphaComponent(0.1)
        contentView.addSubview(label2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var attributedText : NSAttributedString? {
        didSet {
            label1.attributedText = attributedText
            label2.attributedText = attributedText
            setNeedsLayout()
        }
    }
    
    var numberOfLines: Int = 0 {
        didSet {
            label1.numberOfLines = numberOfLines
            label2.numberOfLines = numberOfLines
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = CGFloat(10)
        let maxSize = CGSize(width: self.bounds.width - 2 * padding, height: .greatestFiniteMagnitude)
        let size1 = label1.sizeThatFits(maxSize)
        let size2 = label2.sizeThatFits(maxSize)
        
        label1.frame = CGRect(x: padding, y: padding, width: size1.width, height: size1.height)
        label2.frame = CGRect(x: padding, y: size1.height + 2 * padding, width: size2.width, height: size2.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let padding = CGFloat(10)
        let maxSize = CGSize(width: size.width - 2 * padding, height: size.height)
        let size1 = label1.sizeThatFits(maxSize)
        let size2 = label2.sizeThatFits(maxSize)
        
        return CGSize(width: size.width, height: 10*3 + size1.height + size2.height)
    }
}

class CompareToUILabelViewController: UITableViewController {
    static let defaultLabel = UILabel()
    
    let texts: [[String: Any]] = [
        [
            "text": AttributedTextBuilder(label: defaultLabel).append(string: "My test string!").buildAttributedString(),
            "numberOfLines": 0
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel).append(string: "A long long long long long long long long long longlong long long long long long long long long longlong long long long long long long long long longlong long long long long long long long long long string!").buildAttributedString()
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel).append(string: "NumberOfLines = 2. A long long long long long long long long long longlong long long long long long long long long longlong long long long long long long long long longlong long long long long long long long long long string!").buildAttributedString(),
            "numberOfLines": 2
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel).append(string: "A long string with new line.\nA long string with new line.\nA long string with new line.\nA long string with new line.\nA long string with new line.\n").buildAttributedString()
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel).append(string: "NumberOfLines = 2. A long string with new line.\nA long string with new line.\nA long string with new line.\nA long string with new line.\nA long string with new line.\n").buildAttributedString(),
            "numberOfLines": 2
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel).append(string: "A string with new line & numberOfLines = 1.\n").buildAttributedString(),
            "numberOfLines": 1
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel).append(string: "A string with new line & numberOfLines = 2.\n").buildAttributedString(),
            "numberOfLines": 2
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel).append(string: "A string with new line & numberOfLines = 2.\nA string with new line & numberOfLines = 2.\n").buildAttributedString(),
            "numberOfLines": 2
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel)
                .append(string: "A string with view attachment: ")
                .append(attachment: DDViewAttachment(viewCreator: { () -> UIView in
                    let view = UIView()
                    view.backgroundColor = .red
                    return view
                }, viewSize: CGSize(width: 40, height: 40)))
                .buildAttributedString(),
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel)
                .append(string: "A string whith new line.\nA string with view attachment: ")
                .append(attachment: DDViewAttachment(viewCreator: { () -> UIView in
                    let view = UIView()
                    view.backgroundColor = .red
                    return view
                }, viewSize: CGSize(width: 40, height: 40)))
                .buildAttributedString(),
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel)
                .append(string: "A string with view attachment: ")
                .append(attachment: DDViewAttachment(viewCreator: { () -> UIView in
                    let view = UIView()
                    view.backgroundColor = .red
                    return view
                }, viewSize: CGSize(width: 40, height: 40)))
                .append(string: "\nA string whith new line.")
                .buildAttributedString(),
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel)
                .append(string: "String: 中文与视图富文本")
                .append(attachment: DDViewAttachment(viewCreator: { () -> UIView in
                    let view = UIView()
                    view.backgroundColor = .red
                    return view
                }, viewSize: CGSize(width: 40, height: 40)))
                .buildAttributedString(),
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel)
                .systemFont(ofSize: 15)
                .append(string: "String: 中文与表情包 ")
                .baselineOffset(UIFont.systemFont(ofSize: 15).descender) // minus baseline
                .append(attachment: DDViewAttachment(viewCreator: { () -> UIView in
                    let loading = UIActivityIndicatorView()
                    loading.startAnimating()
                    return loading
                }))
                .buildAttributedString(),
        ],
        [
            "text": AttributedTextBuilder(label: defaultLabel)
                .systemFont(ofSize: 15)
                .append(string: "A string with new line & numberOfLines = 2.\nA string with new line & numberOfLines = 2.\nString: 中文与表情包")
                .baselineOffset(UIFont.systemFont(ofSize: 15).descender) // minus baseline
                .append(attachment: DDViewAttachment(viewCreator: { () -> UIView in
                    let loading = UIActivityIndicatorView()
                    loading.startAnimating()
                    return loading
                }))
                .buildAttributedString(),
            "numberOfLines": 2
        ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.register(MyLabelTableCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyLabelTableCell
        cell.attributedText = texts[indexPath.row]["text"] as? NSAttributedString
        cell.numberOfLines = texts[indexPath.row]["numberOfLines"] as? Int ?? 0
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyLabelTableCell
        cell.attributedText = texts[indexPath.row]["text"] as? NSAttributedString
        cell.numberOfLines = texts[indexPath.row]["numberOfLines"] as? Int ?? 0
        let size = cell.sizeThatFits(CGSize(width: tableView.frame.width, height: .greatestFiniteMagnitude))
        return size.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
