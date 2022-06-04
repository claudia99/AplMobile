//
//  DriverTableViewCell.swift
//  AplMobile
//
//  Created by Claudia Apostol on 05.05.2022.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var constructor: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with driverName:String, driverConstructor: String, driverPoints: String, driverWins: String, id: String) {
        driverImage.image = UIImage(named: id)
        wins.text = "Wins this season: \(driverWins)"
        name.text = driverName
        constructor.text = "Drives for: \(driverConstructor)"
        points.text = "Points this season: \(driverPoints)"
    }

}
