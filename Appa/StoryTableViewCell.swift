//
//  ReviewTableViewCell.swift
//  Appa
//
//  Created by Drew Cappel on 4/26/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyTextLabel: UILabel!
    
    var story: Story! {
        didSet {
            storyTitleLabel.text = story.title
            storyTextLabel.text = story.story
        }
    }


}
