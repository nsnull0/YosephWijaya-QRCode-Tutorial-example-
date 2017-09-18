//
//  CellProductInformationView.swift
//  CarPrice_Barcode
//
//  Created by Yoseph Wijaya on 2017/09/18.
//  Copyright © 2017 Yoseph Wijaya. All rights reserved.
//

import UIKit

class CellProductInformationView: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var qrCodeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var QualityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
