//
//  ViewController.swift
//  DDTextExample
//
//  Created by daniel on 2021/9/11.
//  Copyright © 2021 daniel. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let datas = [
        ["class": CompareToUILabelViewController.self, "title": "Compare to UILabel"],
        ["class": UserActionLabelViewController.self, "title": "DDLabel with user actions"],
        ["class": TextParserViewController.self, "title": "Text parser"],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = datas[indexPath.row]["title"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cls = datas[indexPath.row]["class"] as! UIViewController.Type
        let vc = cls.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

