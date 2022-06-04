//
//  NetworkingManager.swift
//  AplMobile
//
//  Created by Claudia Apostol on 15.05.2022.
//

import Foundation
import Alamofire

class NetworkingManager {
    
    func fetchDrivers() -> [StandingsList] {
        var driversToSend: [StandingsList]?
        let request = AF.request("https://ergast.com/api/f1/current/driverStandings.json")
            .validate()
            .responseDecodable(of: DriverStandings.self) { (response) in
                switch response.result {
                case .success(let users):
                    driversToSend = users.data.standingsTable?.standingsLists
                    //self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        return driversToSend!
    }
    
    func fetchConstructors() -> [ConstructorStandings] {
        var constructors: [ConstructorStandings]?
        let request = AF.request("http://ergast.com/api/f1/current/constructorStandings.json")
            .validate()
            .responseDecodable(of: Constructors.self) { (response) in
                switch response.result {
                case .success(let constr):
                    constructors = constr.data.constructorTable.standingsLists[0].constructorStandings!
//                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        return constructors!
    }
    
}
