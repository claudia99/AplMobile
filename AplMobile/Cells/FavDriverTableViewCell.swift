//
//  FavDriverTableViewCell.swift
//  AplMobile
//
//  Created by Claudia Apostol on 23.05.2022.
//

import UIKit

class FavDriverTableViewCell: UITableViewCell {

    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with driverName:String, id: String) {
        driverImage.image = UIImage(named: id)
        driverLabel.text = driverName
    }
}
