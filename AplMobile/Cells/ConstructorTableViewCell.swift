//
//  ConstructorTableViewCell.swift
//  AplMobile
//
//  Created by Claudia Apostol on 15.05.2022.
//

import UIKit

class ConstructorTableViewCell: UITableViewCell {

    @IBOutlet weak var driversLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var constructorLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with constructor:String, points: String, wins: String, id: String, drivers: [String]) {
        logoImageView.image = UIImage(named: id)
        pointsLabel.text = "Points this season: \(points)"
        winsLabel.text = "Wins this season: \(wins)"
        driversLabel.text = "Drivers: \(drivers[0]) \(drivers[1]), \(drivers[2]) \(drivers[3])"
        constructorLabel.text = constructor
    }
    
}
