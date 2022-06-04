//
//  AddDriverViewController.swift
//  AplMobile
//
//  Created by Claudia Apostol on 16.05.2022.
//

import UIKit
import Alamofire
import CoreData

class AddDriverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    var driverss: [FavDriver] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredDrivers: [String] = []
    var driverNames: [String] = []
    var drivers: [Driver] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        fetchAllDrivers()
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Drivers"
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.systemRed
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredDrivers = driverNames.filter { (driver: String) -> Bool in
        return driver.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }
 
    func getDriver(name: String) -> Driver {
        var driverToSend: Driver?
        for dr in drivers {
            let fullName = dr.givenName + " " + dr.familyName
            if fullName == name { driverToSend = dr}
        }
        return driverToSend!
    }
}
extension AddDriverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredDrivers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddDriverTableViewCell", for: indexPath) as! AddDriverTableViewCell
        var candy: String = ""
        if isFiltering {
            candy = filteredDrivers[indexPath.row]
        }
        cell.nameLabel.text = candy
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var isInDatabase = 0
        var existingDriver: FavDriver?
        var alertMessage: String = ""
        var okMessage: String = ""
        do {
            let request = FavDriver.fetchRequest() as NSFetchRequest<FavDriver>
            let pred = NSPredicate(format: "driverId CONTAINS '\(self.getDriver(name: self.filteredDrivers[indexPath.row]).driverId)'")
            request.predicate = pred
            let count = try self.context.count(for: request)
            if count>0 {
                isInDatabase = 1
                existingDriver = try! self.context.fetch(request).first
                alertMessage = "It looks like \(filteredDrivers[indexPath.row]) is already on your list. Do you want to give him a higher priority?"
                okMessage = "Yes, please"
            } else {
                isInDatabase = 0
                alertMessage = "Are you sure you want to add \(filteredDrivers[indexPath.row]) to your favourites list?"
                okMessage = "I'm sure"
            }
        }
        catch {
            
        }
        let alert = UIAlertController(title: "Wait a minute...", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okMessage, style: .default, handler: { action in
            switch isInDatabase {
            case 1:
                existingDriver!.priority+=1
            default:
                let newDriver = FavDriver(context: self.context)
                newDriver.name = self.filteredDrivers[indexPath.row]
                newDriver.url = self.getDriver(name: self.filteredDrivers[indexPath.row]).url
                newDriver.code = self.getDriver(name: self.filteredDrivers[indexPath.row]).code
                newDriver.driverId = self.getDriver(name: self.filteredDrivers[indexPath.row]).driverId
                newDriver.dateOfBirth = self.getDriver(name: self.filteredDrivers[indexPath.row]).dateOfBirth
                newDriver.permanentNumber = self.getDriver(name: self.filteredDrivers[indexPath.row]).permanentNumber
                newDriver.nationality = self.getDriver(name: self.filteredDrivers[indexPath.row]).nationality
                newDriver.priority = 0
            }
            
            

            try! self.context.save()
            self.dismiss(animated: true)
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Nope, nevermind", style: .destructive, handler: {_ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddDriverViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension AddDriverViewController {
    func fetchAllDrivers(){
        let request = AF.request("http://ergast.com/api/f1/drivers.json?limit=1000")
            .validate()
            .responseDecodable(of: DriverStandings.self) { (response) in
                switch response.result {
                case .success(let users):
                    self.drivers = users.data.driverTable!.drivers
                    for dr in users.data.driverTable!.drivers {
                        let fullName = dr.givenName + " " + dr.familyName
                        self.driverNames.append(fullName)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension AddDriverViewController {
    func fetchDrivers() {
        do {
            try self.driverss = context.fetch(FavDriver.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
}
