//
//  ViewController.swift
//  CloudFunctionExample
//
//  Created by Fomagran on 2020/12/06.
//

import UIKit
import FirebaseFunctions

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    lazy var functions = Functions.functions()

    override func viewDidLoad() {
        super.viewDidLoad()
        let data = ["text": "Hello World!"]

              functions.httpsCallable("helloWorld").call(data) { (result, error) in
                  print("Function returned")
                  if let err = error {
                      print(err)
                  }
                
                  if let res = result {
                    let resdic = res.data as? [String:Any]
                    self.label.text = resdic!["message"] as? String
                  }
              }
    }


}

