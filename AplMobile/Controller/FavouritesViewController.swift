//
//  FavouritesViewController.swift
//  AplMobile
//
//  Created by Claudia Apostol on 05.05.2022.
//

import UIKit
import CoreData
import Alamofire
import UserNotifications

class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate {
  
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let refreshControl = UIRefreshControl()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var driverStandings: [DriverStandings] = []
    var drivers: [StandingsList] = []
    var driverss: [FavDriver] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNotificationCenter.delegate = self
        self.requestNotificationAuthorization()
        self.sendNotification()
        
        tableView.tableFooterView = UIView()
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        fetchDrivers()
    }
    @objc func refresh(_ sender: AnyObject) {
        self.fetchDrivers()
        self.refreshControl.endRefreshing()

    }
    
    func fetchDrivers() {
        do {
            let request = FavDriver.fetchRequest() as NSFetchRequest<FavDriver>
            let sort = NSSortDescriptor(key: "priority", ascending: false)
            request.sortDescriptors = [sort]
            try self.driverss = context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Screen1", bundle: nil).instantiateViewController(withIdentifier: "AddDriverViewController") as? AddDriverViewController {
              if let navigator = navigationController {
                  navigator.pushViewController(viewController, animated: true)
              }
          }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavDriverTableViewCell", for: indexPath) as! FavDriverTableViewCell
        let currentDriver = driverss[indexPath.row]
        cell.configure(with: currentDriver.name, id: currentDriver.driverId!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if driverss.isEmpty {
            return 0
        }
        return driverss.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DriverDetailsViewController") as? DriverDetailsViewController
        let driverToSend: FavDriver?
        do {
            let request = FavDriver.fetchRequest() as NSFetchRequest<FavDriver>
            let pred = NSPredicate(format: "driverId CONTAINS '\(driverss[indexPath.row].driverId!)'")
            request.predicate = pred
            driverToSend = try context.fetch(request).first
            vc?.driverToDisplay = driverToSend
            present(vc!, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let driverToRemove = self.driverss[indexPath.row]
            self.context.delete(driverToRemove)
            do{
                try self.context.save()
            }
            catch {
                
            }
            self.fetchDrivers()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

extension FavouritesViewController {
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    func sendNotification() {
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()

        // Add the content to the notification content
        notificationContent.title = "Vrooom"
        notificationContent.body = "Today is race day!!! Keep an eye on the Driver Standings."
        notificationContent.badge = NSNumber(value: 1)
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 6 //1
        dateComponents.hour = 17
        dateComponents.minute = 45
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "testNotification",
                                                content: notificationContent,
                                                trigger: trigger)
            
        userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
    }
}
