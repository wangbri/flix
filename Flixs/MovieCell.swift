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
    
    var dimView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func setSelected(selected: Bool, animated: Bool) {
        setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //posterView.alpha = 0
        
    }
    
    override var highlighted: Bool {
        didSet {
            if self.highlighted {
                posterView.alpha = 0.85
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 222.0/255.0, blue: 120.0/255.0, alpha: 0.05)

                self.selectedBackgroundView = backgroundView
                //posterView.image = posterView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                //posterView.tintColor = UIColor(red: 255.0/255.0, green: 222.0/255.0, blue: 120.0/255.0, alpha: 0.05)


            }
            else {
                posterView.alpha = 1.0
            }
        }
    }


}
