//
//  PostCell.swift
//  Parstagram
//
//  Created by LiYang on 3/25/22.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var captionText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
