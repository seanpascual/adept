//
//  WebViewController.swift
//  DEP-Enrolment
//
//  Copyright © 2017 Trams Ltd. All rights reserved.
//
//  Designed for Use with Jamf Pro.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Trams Ltd. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Cocoa
import WebKit

class WebViewController: NSViewController {

    @IBOutlet weak var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load HTML Content
        let htmlPage = Bundle.main.url(forResource: "index", withExtension: "html")
        webView.mainFrame.load(URLRequest(url: htmlPage!))
        
        // Load Web Page (commented out)
        //let url = NSURL (string: "https://tramscloud.co.uk")
        //webView.mainFrame.load(URLRequest(url: url as! URL))
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        
        NSApplication.shared.terminate(self)
        
    }
    
}
