//
//  CustomTableViewCell.swift
//  KongGuy
//
//  Created by Nontapat Siengsanor on 1/2/2564 BE.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarView?.backgroundColor = .brown
    }

}
