//
//  CommentCell.swift
//  Parstagram
//
//  Created by LiYang on 4/2/22.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var author: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
