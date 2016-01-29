//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mikael Mukhsikaroyan on 1/17/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    private var _filePathUrl: NSURL!
    private var _title: String!
    
    var filePathUrl: NSURL {
        return _filePathUrl
    }
    
    var title: String {
        return _title
    }
    
    init(filePath: NSURL, title: String) {
        self._filePathUrl = filePath
        self._title = title
    }
    
}
