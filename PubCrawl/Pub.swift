//
//  Pub.swift
//  PubCrawl
//
//  Created by Jacob Bartlett on 20/03/2025.
//

import Foundation
import MapKit

// https://circlelinepubcrawl.co.uk
struct Pub: Codable, Equatable {
    let stop: Int
    let pubName: String
    let station: String
    let description: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case stop
        case pubName
        case station
        case description
        case address
        case coordinate
    }
    
    enum CoordinateKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stop, forKey: .stop)
        try container.encode(pubName, forKey: .pubName)
        try container.encode(station, forKey: .station)
        try container.encode(description, forKey: .description)
        try container.encode(address, forKey: .address)
        
        var coordinateContainer = container.nestedContainer(keyedBy: CoordinateKeys.self, forKey: .coordinate)
        try coordinateContainer.encode(coordinate.latitude, forKey: .latitude)
        try coordinateContainer.encode(coordinate.longitude, forKey: .longitude)
    }
    
    var visited: Bool = false
    
    static func ==(lhs: Pub, rhs: Pub) -> Bool {
        lhs.stop == rhs.stop
    }
    
    init(stop: Int, pubName: String, station: String, description: String, address: String, coordinate: CLLocationCoordinate2D, visited: Bool = false) {
        self.stop = stop
        self.pubName = pubName
        self.station = station
        self.description = description
        self.address = address
        self.coordinate = coordinate
        self.visited = visited
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stop = try container.decode(Int.self, forKey: .stop)
        pubName = try container.decode(String.self, forKey: .pubName)
        station = try container.decode(String.self, forKey: .station)
        description = try container.decode(String.self, forKey: .description)
        address = try container.decode(String.self, forKey: .address)
        
        let coordinateContainer = try container.nestedContainer(keyedBy: CoordinateKeys.self, forKey: .coordinate)
        let lat = try coordinateContainer.decode(CLLocationDegrees.self, forKey: .latitude)
        let lon = try coordinateContainer.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
