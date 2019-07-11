//
//  Photo.swift
//  QuotePro
//
//  Created by Cameron Mcleod on 2019-07-10.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import Foundation
import UIKit

class Photo {
    let width: Int
    let height: Int
    let image: UIImage
    
    init(width: Int, height: Int, image: UIImage) {
        self.width = width
        self.height = height
        self.image = image
    }
}
