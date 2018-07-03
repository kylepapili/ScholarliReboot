//
//  CourseTableViewCell.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/29/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet var Period: UILabel!
    @IBOutlet var TeacherName: UILabel!
    @IBOutlet var CourseTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
