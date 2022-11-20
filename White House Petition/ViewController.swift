//
//  ViewController.swift
//  White House Petition
//
//  Created by Aasem Hany on 20/11/2022.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        var config = currentCell.defaultContentConfiguration()
        config.text = "Title Goes Here"
        config.secondaryText = "Subtitle Goes Here"
        currentCell.contentConfiguration = config
        return currentCell
    }
}

