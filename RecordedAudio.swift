//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Aditya Ramayanam on 6/5/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathURL: NSURL, title: String) {
        self.filePathUrl = filePathURL
        self.title = title
    }
    
}