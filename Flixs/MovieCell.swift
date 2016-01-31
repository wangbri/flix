//
//  MovieCell.swift
//  Flixs
//
//  Created by Brian Wang on 1/25/16.
//  Copyright © 2016 wangco. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    //@IBOutlet weak var overviewLabel: UILabel!

    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

}
