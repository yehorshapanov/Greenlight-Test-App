//
//  ViewController.swift
//  Greenlight Test App
//
//  Created by Yehor Shapanov on 11/14/18.
//  Copyright © 2018 Yehor Shapanov. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class TableViewController: UITableViewController {
    var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        self.notificationToken = realm.observe { [unowned self] note, realm in
            self.tableView.reloadData()
        }
        get(type: Repo.self)
        setupUI()
    }
    
    func get<T: Object> (type: T.Type)
        where T:Mappable, T:API {
            Alamofire.request(type.url())
                .responseArray { (response: DataResponse<[T]>) in
                    switch response.result {
                    case .success(let items):
                        DispatchQueue(label: "background").async {
                            autoreleasepool {
                                do {
                                    let realm = try Realm()
                                    try realm.write {
                                        for item in items {
                                            realm.add(item, update: true)
                                        }
                                    }
                                } catch let error as NSError {
                                    print("unhandled error: \(error)")
                                }
                            }
                        }
                    case .failure(let error):
                        print("unhandled error: \(error)")
                    }
            }
    }
    
    func setupUI() {
        title = "Realm repos"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()

        return realm.objects(Repo.self).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let realm = try! Realm()
        
        let repos = realm.objects(Repo.self)
        let repo = repos[indexPath.row]
        cell.textLabel?.text = repo.name + "\tNum issues: \(repo.issuesCount)"
        return cell
    }
}


