//
//  StandingsViewController.swift
//  AplMobile
//
//  Created by Claudia Apostol on 14.05.2022.
//

import UIKit
import Alamofire

class StandingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var standingsSegmentedControl: UISegmentedControl!
    
    var drivers: [StandingsList]?
    var constructors: [ConstructorStandings]?
    let networkingManager: NetworkingManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        fetchDrivers()
        fetchConstructors()
    }

    func getDriversForConstructor(constr: String) -> [String]{
        var driversForConstructor: [String] = []
        drivers![0].driverStandings!
            .forEach {
            if $0.constructors[0].constructorId == constr {
                driversForConstructor.append( $0.driver.givenName)
                driversForConstructor.append( $0.driver.familyName)
            }
        }
        return driversForConstructor
    }
    
    @IBAction func sectionDidChange(_ sender: Any) {
        tableView.reloadData()
    }
    
}

extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let totalConstr = constructors?.count, let totalDrivers = drivers?[0].driverStandings?.count else {
            return 0
        }
        if standingsSegmentedControl.selectedSegmentIndex == 0 {
            return totalDrivers
        }
        return totalConstr
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if standingsSegmentedControl.selectedSegmentIndex == 0 {
            return 150
        }
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch standingsSegmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DriverTableViewCell") as! DriverTableViewCell
            let currentDriver = drivers?[0].driverStandings![indexPath.row]
            let fullName = (currentDriver?.driver.givenName)! + " " + (currentDriver?.driver.familyName)!
            print(currentDriver?.driver.driverId)
            cell.configure(with: fullName, driverConstructor: (currentDriver?.constructors[0].name)!,driverPoints: currentDriver!.points, driverWins: currentDriver!.wins, id: currentDriver!.driver.driverId)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConstructorTableViewCell") as! ConstructorTableViewCell
            cell.configure(with: constructors![indexPath.row].constructor!.name, points: constructors![indexPath.row].points!, wins: constructors![indexPath.row].wins!, id: constructors![indexPath.row].constructor!.constructorId, drivers: getDriversForConstructor(constr: constructors![indexPath.row].constructor!.constructorId))
            return cell
        }
    }
}

extension StandingsViewController {
    func fetchConstructors() {
        let request = AF.request("http://ergast.com/api/f1/current/constructorStandings.json")
            .validate()
            .responseDecodable(of: Constructors.self) { (response) in
                switch response.result {
                case .success(let constr):
                    self.constructors = constr.data.constructorTable.standingsLists[0].constructorStandings!
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func fetchDrivers(){
        var driversToSend: [StandingsList]?
        let request = AF.request("https://ergast.com/api/f1/current/driverStandings.json")
            .validate()
            .responseDecodable(of: DriverStandings.self) { (response) in
                switch response.result {
                case .success(let users):
                    print(users.data)
                    self.drivers = users.data.standingsTable?.standingsLists
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}
