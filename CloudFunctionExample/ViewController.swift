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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    let client = SearchClient(appID: "Y5P2EINUZX", apiKey: "c9aaa4b59720bc3defceba9c60be907d")
    lazy var index = client.index(withName: "test")
    var users:[User] = []
    var filterUsers:[User] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        deleteObject()
    }
    
    private func configure() {
        searchBar.delegate = self
        table.dataSource = self
    }
    
    private func searchAlgolia(searchText:String) {
        
        index.search(query: "\(searchText)") { result in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let response):
                print("Response: \(response.hits)")
                do {
                    self.filterUsers = try response.extractHits()
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                } catch let error {
                    print("Contact parsing error: \(error)")
                }
            }
        }
        
    }
    
    private func sortAlgolia() {
        let settings = Settings()
            .set(\.customRanking, to: [.asc("age")])
        index.setSettings(settings) { result in
            switch result {
            case .failure(let error):
                print("Error when applying settings: \(error)")
            case .success:
                print("Success")
            }
        }
    }
    
    private func updateObject() {
        let updates: [(ObjectID, PartialUpdate)] = [
          ("1111212002", .update(attribute: "age", value: 30))
        ]

        index.partialUpdateObjects(updates: updates) { result in
          if case .success(let response) = result {
            print("Response: \(response)")
          }
        }
    }
    
    
    private func saveToAlgolia(){
        index.saveObjects(users, autoGeneratingObjectID: true) { result in
            if case .success(let response) = result {
                print("Response: \(response)")
            }
        }
    }
    
    private func deleteObject() {
        index.deleteObject(withID: "1111212002") { result in
          if case .success(let response) = result {
            print("Response: \(response)")
          }
        }
    }
    
    private func setUsers() {
        let user1 = User(name: "Foma", age: 26, desc: "안녕하세요 저는 포마입니다. 만나서 반가워요~")
        let user2 = User(name: "gran", age: 27, desc: "안녕하세요 저는 그랜입니다. 처음뵙겝습니다.")
        let user3 = User(name: "Fomagran", age: 28, desc: "포마그랜입니다!!")
        
        users = [user1,user2,user3]
    }
    
    
    func create() {
        Firestore.firestore().collection("users").document("fomagran").setData(["name":"some","age":1,"description":"hi"])
    }
    
    func update() {
        Firestore.firestore().collection("users").document("fomagran").updateData(["age":101])
    }
    
    func delete() {
        Firestore.firestore().collection("users").document("fomagran").delete()
    }
    
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filterUsers[indexPath.row].name
        return cell
    }
}

extension ViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAlgolia(searchText: searchBar.text ?? "")
    }
}
