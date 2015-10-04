//
//  Channel.swift
//  News Reader
//
//  Created by Alexey on 02.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class Channel: NSObject {
    var title: String?
    var link: String?
    var channelDescription: String?
    
    var items = [Item]()
    
    override init() {
        super.init()
    }
}
