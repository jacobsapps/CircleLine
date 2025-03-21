//
//  ContentView.swift
//  PubCrawl
//
//  Created by Jacob Bartlett on 18/03/2025.
//

import MapKit
import SwiftUI

// TODO:
// 1. Expand icon / recolor when selected ✅
// 2. "Next pub" with Keyframeanimator ✅
// 3. MapPolyline ✅
// 4. Start / next / back buttons as controls
//
struct MapView: View {
    @StateObject private var pubService = PubService()
    
    @State private var scene: MKLookAroundScene?
    
    var body: some View {
        Map(position: $pubService.cameraPosition) {
            circleLine
            mapAnnotations
        }
        .mapStyle(.hybrid)
        .ignoresSafeArea()
        .onChange(of: pubService.selectedPub) { _, pub in
            if let pub {
                Task {
                    scene = try? await fetchScene(for: pub)
                }
            }
        }
        .overlay(alignment: .topLeading) {
            if pubService.selectedPub != nil {
                Button("Back") {
                    pubService.deselect()
                }
                .contentShape(Rectangle())
                .padding()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if pubService.selectedPub != nil {
                LookAroundPreview(scene: $scene, allowsNavigation: true, badgePosition: .bottomTrailing)
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
            }
        }
        .mapCameraKeyframeAnimator(trigger: pubService.selectedPub, keyframes: { camera in
            KeyframeTrack(\.centerCoordinate) {
                CubicKeyframe(pubService.selectedPub?.coordinate ?? PubService.Constants.london, duration: pubService.previousPub == nil ? 1 : 2.1)
            }
            KeyframeTrack(\.distance) {
                if pubService.previousPub == nil {
                    CubicKeyframe(pubService.selectedPub == nil ? 12_000 : 4_000, duration: 2.1)
                } else if pubService.selectedPub == nil {
                    CubicKeyframe(12_000, duration: 1)
                } else {
                    CubicKeyframe(750, duration: 0.7)
                    LinearKeyframe(750, duration: 0.7)
                    SpringKeyframe(4_000, duration: 0.7)
                }
            }
        })
    }
    
    private var circleLine: some MapContent {
        MapPolyline(
            coordinates: pubService.pubs.map(\.coordinate) + [pubService.pubs.first?.coordinate].compactMap{ $0 },
            contourStyle: .geodesic
        )
        .mapOverlayLevel(level: .aboveRoads)
        .stroke(.yellow, style: .init(lineWidth: 4))
    }
    
    private var mapAnnotations: some MapContent {
        ForEach(pubService.pubs, id: \.stop) { pub in
            Annotation("\(pub.pubName)\n(\(pub.station))", coordinate: pub.coordinate) {
                Button(action: {
                    pubService.select(pub: pub)
                }, label: {
                    PubAnnotationView(pub: pub,
                                      isSelected: (pubService.selectedPub?.stop == pub.stop))
                    .buttonStyle(.plain)
                })
                .animation(.bouncy, value: pubService.selectedPub)
            }
        }
    }
    
    private func fetchScene(for pub: Pub) async throws -> MKLookAroundScene? {
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: pub.coordinate)
        return try await lookAroundScene.scene
    }
}

#Preview {
    MapView()
}
