//
//  LogsTableViewCell.swift
//  Affinion
//
//  Created by Dennis Menjivar on 3/22/16.
//  Copyright © 2016 Dennis Menjivar. All rights reserved.
//

import UIKit

class LogsTableViewCell: UITableViewCell {
    @IBOutlet weak var VendorAndSite: UILabel!
    @IBOutlet weak var FileReceived: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Percent: UILabel!
    @IBOutlet weak var PGPFound: UILabel!
    @IBOutlet weak var PGPIntegrity: UILabel!
    @IBOutlet weak var ZIPIntegrity: UILabel!
    @IBOutlet weak var CSVTransmitted: UILabel!
    @IBOutlet weak var CsvContainsData: UILabel!
    @IBOutlet weak var RecordsReceived: UILabel!
    @IBOutlet weak var RecordsLoaded: UILabel!
    @IBOutlet weak var Comment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
