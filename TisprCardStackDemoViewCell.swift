/*
Copyright 2015 BuddyHopp, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

//
//  TisprCardStackDemoViewCell.swift
//  TisprCardStack
//
//  Created by Andrei Pitsko on 7/12/15.
//

import UIKit

class TisprCardStackDemoViewCell: TisprCardStackViewCell {
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var  voteSmile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12
        clipsToBounds = false
        
    }
    
    override var center: CGPoint {
        didSet {
            updateSmileVote()
        }
    }
    
    override internal func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        updateSmileVote()
    }
    
    func updateSmileVote() {
        let rotation = atan2(transform.b, transform.a) * 100
        var smileImageName = "smile_neutral"
        
        if rotation > 15 {
            smileImageName = "smile_face_2"
        } else if rotation > 0 {
            smileImageName = "smile_face_1"
        } else if rotation < -15 {
            smileImageName = "smile_rotten_2"
        } else if rotation < 0 {
            smileImageName = "smile_rotten_1"
        }
        
        voteSmile.image = UIImage(named: smileImageName)
    }


}
