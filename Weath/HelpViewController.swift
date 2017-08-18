//
//  SecondViewController.swift
//  Weath
//
//  Created by Marcus Johnson on 8/13/17.
//  Copyright © 2017 weather. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.loadHTMLString(
            Constants.WEBVIEW_HTML, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

