//
//  ContentView.swift
//  MapIsGood
//
//  Created by Jacob Bartlett on 18/03/2025.
//

import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var pubService = PubService()
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 51.5077, longitude: -0.1300),
                  distance: 12_000,
                  heading: .zero)
    )
    @State private var scene: MKLookAroundScene?
    
    var body: some View {
        Map(position: $cameraPosition) {
            mapAnnotations
        }
        .mapStyle(.standard)
        .ignoresSafeArea()
        .onChange(of: pubService.selectedPub) {
            if let pub = $0 {
                Task {
                    scene = try? await fetchScene(for: pub)
                }
            }
        }
        .overlay(alignment: .bottom) {
            if pubService.selectedPub != nil {
                LookAroundPreview(scene: $scene, allowsNavigation: false, badgePosition: .bottomTrailing)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .safeAreaPadding(.bottom, 40)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    //    private var circleLine: MapPolyline {
    //            MapPolyline(
    //                coordinates: pubService.pubs.compactMap(\.coordinate),
    //                contourStyle: .geodesic
    //            )
    //            }
    //    }
    
    private var mapAnnotations: some MapContent {
        ForEach(pubService.pubs.filter { $0.coordinate != nil }, id: \.station) { pub in
            // TODO: Add a toggle so I can check off the pubs! Put it in a sheet
            Annotation("\(pub.stop): \(pub.pubName)", coordinate: pub.coordinate!) {
                Button(action: {
                    pubService.selectedPub = pub
                }, label: {
                    PubAnnotationView(pub: pub)
                })
            }
        }
    }
    
    private func fetchScene(for pub: Pub) async throws -> MKLookAroundScene? {
        guard let coordinate = pub.coordinate else { return nil }
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
        return try await lookAroundScene.scene
    }
}

#Preview {
    MapView()
}
