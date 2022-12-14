//
//  ViewController.swift
//  White House Petition
//
//  Created by Aasem Hany on 20/11/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions:Petitions?
    var filteredData = [Petition]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        let urlString = isTopRated()
        ? "https://www.hackingwithswift.com/samples/petitions-2.json" : "https://www.hackingwithswift.com/samples/petitions-1.json"
        performSelector(inBackground: #selector(fetchJson), with: urlString)
    }
    
    @objc func fetchJson(withUrl urlString:String){
        
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                // We're Okay To Parse That Data
                parseJson(json: data)
                performSelector(onMainThread: #selector(reloadTableViewData), with: nil, waitUntilDone: false)
                return
            }
            performSelector(onMainThread: #selector(showError), with: self, waitUntilDone: false)
        }
        
    }
    
     func configNavBar() {
        title = isTopRated() ? "Top Rated Petitions" : "Most Recent Petitions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Press Me", style: .done, target: self, action: #selector(onInfoPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(onFilterPressed))
    }
    
    
    @objc func reloadTableViewData() {
        tableView.reloadData()
    }
    
    @objc func onFilterPressed() {
        let ac = UIAlertController(title: "Filter Petitions", message:nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Filter", style: .default, handler: {[weak self,weak ac] _ in
            guard let filterText = ac?.textFields?[0].text else {return}
            self?.performSelector(inBackground: #selector(self?.filterData), with: filterText)
            
        }))
        present(ac, animated: true)
    }
    
    
    @objc func filterData(withText filterText: String){
        if (filterText.isEmpty) {
            filteredData.removeAll()
            performSelector(onMainThread: #selector(reloadTableViewData), with: nil, waitUntilDone: false)
            return
        }
        
        let filteredResults = petitions?.results.filter({
            $0.title.hasPrefix(filterText)})
        if let safeFilteredResults = filteredResults
        {
            filteredData = safeFilteredResults
            performSelector(onMainThread: #selector(reloadTableViewData), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func onInfoPressed() {
        let ac = UIAlertController(title: "Hello", message: "This app data is from the People API", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(ac, animated: true)
    }
     private func isTopRated() -> Bool {

        return navigationController?.tabBarItem.tag == 1
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parseJson(json:Data){
        let decoder = JSONDecoder ()
        if let petitionsData = try? decoder.decode(Petitions.self, from: json){
            petitions = petitionsData
        }else{
            performSelector(onMainThread: #selector(showError), with: self, waitUntilDone: false)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.isEmpty ? petitions?.results.count ?? 0 : filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        currentCell.textLabel?.text = filteredData.isEmpty ? (petitions?.results[indexPath.row].title ?? "") : filteredData[indexPath.row].title
        currentCell.detailTextLabel?.text = filteredData.isEmpty ? (petitions?.results[indexPath.row].body ?? "") :
        filteredData[indexPath.row].body
        return currentCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PetitionDetailViewController()
        vc.petition = filteredData.isEmpty ? petitions?.results[indexPath.row] : filteredData[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

