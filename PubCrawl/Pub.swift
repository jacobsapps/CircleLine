//
//  Pub.swift
//  MapIsGood
//
//  Created by Jacob Bartlett on 20/03/2025.
//

import Foundation
import MapKit

// Circle line pub crawl:
// https://circlelinepubcrawl.co.uk
struct Pub: Decodable, Equatable {
    let stop: Int
    let pubName: String
    let station: String
    let description: String
    let address: String
    var coordinate: CLLocationCoordinate2D?
    var visited: Bool = false
    
    static func ==(lhs: Pub, rhs: Pub) -> Bool {
        lhs.stop == rhs.stop
    }
    
    enum CodingKeys: String, CodingKey {
        case stop
        case pubName
        case station
        case description 
        case address
    }
}
