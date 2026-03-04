//
//  Item.swift
//  AirAlign
//
//  Created by Uriel Castillo on 04/03/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
