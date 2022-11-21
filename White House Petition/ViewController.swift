//
//  ViewController.swift
//  White House Petition
//
//  Created by Aasem Hany on 20/11/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions:Petitions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recent Petitions"
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                // We're Okay To Parse That Data
                parseJson(json: data)
                tableView.reloadData()
            }
        }
    }
    
    func parseJson(json:Data){
        let decoder = JSONDecoder ()
        if let petitionsData = try? decoder.decode(Petitions.self, from: json){
            petitions = petitionsData
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
//        var config = currentCell.defaultContentConfiguration()
//        config.text = petitions?.results[indexPath.row].title ?? ""
//        config.secondaryText = petitions?.results[indexPath.row].body ?? ""
//        currentCell.contentConfiguration = config
        currentCell.textLabel?.text = petitions?.results[indexPath.row].title ?? ""
        currentCell.detailTextLabel?.text = petitions?.results[indexPath.row].body ?? ""
        return currentCell
    }
}

