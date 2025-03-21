//
//  PubService.swift
//  PubCrawl
//
//  Created by Jacob Bartlett on 18/03/2025.
//

import Foundation
import SwiftUI
import MapKit

final class PubService: ObservableObject {
    @Published var cameraPosition: MapCameraPosition
    @Published private(set) var pubs: [Pub] = []
    @Published private(set) var selectedPub: Pub?
    @Published private(set) var previousPub: Pub?
    
    enum Constants {
        static let london = CLLocationCoordinate2D(latitude: 51.5077, longitude: -0.1300)
    }
    
    let defaultCamera: MapCamera = MapCamera(
        centerCoordinate: Constants.london,
        distance: 12_000,
        heading: .zero
    )
    
    init() {
        cameraPosition = .camera(defaultCamera)
        try? loadPubCrawl()
    }
    
    func select(pub: Pub) {
        previousPub = selectedPub
        selectedPub = pub
    }
    
    func deselect() {
        previousPub = selectedPub
        selectedPub = nil
    }
    
    private func loadPubCrawl() throws {
        let url = Bundle.main.url(forResource: "pubs", withExtension: "json")!
        let data = try Data(contentsOf: url)
        pubs = try JSONDecoder().decode([Pub].self, from: data)
    }
}
