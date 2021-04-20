//
//  ViewController.swift
//  CloudFunctionExample
//
//  Created by Fomagran on 2020/12/06.
//

import UIKit
import FirebaseFunctions
import AlgoliaSearchClient
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    lazy var functions = Functions.functions(region: "us-central1")
    
    
    struct Name: Codable {
      let firstname: String
      let lastname: String
      let followers: Int
      let company: String
    }

    let names: [Name] = [
      .init(firstname: "Jimmie", lastname: "Barninger", followers: 93, company: "California Paint"),
      .init(firstname: "Warren", lastname: "Speach", followers: 42, company: "Norwalk Crmc")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        create()
//        update()
//        delete()

//        let client = SearchClient(appID: "Y5P2EINUZX", apiKey: "c9aaa4b59720bc3defceba9c60be907d")
//        let index = client.index(withName: "test")
        
//        index.saveObjects(names, autoGeneratingObjectID: true) { result in
//          if case .success(let response) = result {
//            print("Response: \(response)")
//          }
//        }
        
//        let settings = Settings()
//          .set(\.customRanking, to: [.desc("followers")])
//        index.setSettings(settings) { result in
//          switch result {
//          case .failure(let error):
//            print("Error when applying settings: \(error)")
//          case .success:
//            print("Success")
//          }
//        }
        
        // Search for a first name
//        index.search(query: "jimmie") { result in
//          switch result {
//          case .failure(let error):
//            print("Error: \(error)")
//          case .success(let response):
//            print("Response: \(response.hits)")
//            do {
//                let foundContacts: [Name] = try response.extractHits()
//              print("Found contacts: \(foundContacts)")
//            } catch let error {
//              print("Contact parsing error: \(error)")
//            }
//          }
//        }
        
    }
    
    func create() {
        Firestore.firestore().collection("users").addDocument(data:["name":"some","age":1,"description":"hi"])
    }
    
    func update() {
        Firestore.firestore().collection("users").document("some").updateData(["age":101])
    }
    
    func delete() {
        Firestore.firestore().collection("users").document("some").delete()
    }
    
}

