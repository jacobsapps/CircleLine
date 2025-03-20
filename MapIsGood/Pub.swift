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
struct Pub: Decodable {
    let stop: Int
    let pubName: String
    let station: String
    let description: String
    let address: String
    var coordinate: CLLocationCoordinate2D?
    var visited: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case stop
        case pubName
        case station
        case description 
        case address
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        pubName = try container.decode(String.self, forKey: .pubName)
//        station = try container.decode(String.self, forKey: .station)
//        let latitude = try container.decode(Double.self, forKey: .latitude)
//        let longitude = try container.decode(Double.self, forKey: .longitude)
//        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
}
