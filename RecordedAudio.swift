//
//  RecordedAudio.swift
//  Pitch Pefect
//
//  Created by John Ceniza on 6/13/15.
//  Copyright (c) 2015 AppDeco. All rights reserved.
//

//JC Notes: by default new classes imports Foundation - which is basically necessary for all objects in iOS Development

import Foundation

//JC Notes: We inherit from NSObject here because it is the base class for most items and we just need to store strings and array
class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
}
