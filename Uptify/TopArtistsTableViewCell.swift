//
//  TopArtistsTableViewCell.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit

class TopArtistsTableViewCell: UITableViewCell {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
