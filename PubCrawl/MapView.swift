//
//  ContentView.swift
//  PubCrawl
//
//  Created by Jacob Bartlett on 18/03/2025.
//

import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var pubService = PubService()
    @State private var scene: MKLookAroundScene?
    @State private var mapStyle: MapStyle = .standard
    
    var body: some View {
        Map(position: $pubService.cameraPosition) {
            circleLine
            mapAnnotations
        }
        .mapStyle(mapStyle)
        .ignoresSafeArea()
        .onChange(of: pubService.selectedPub) { _, pub in
            if let pub {
                Task {
                    scene = try? await fetchScene(for: pub)
                }
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1))
            mapStyle = .hybrid(elevation: .realistic)
        }
        .overlay(alignment: .topLeading) {
            backButton
        }
        .overlay(alignment: .bottomTrailing) {
            lookAroundPreview
        }
        .mapCameraKeyframeAnimator(trigger: pubService.selectedPub, keyframes: { camera in
            KeyframeTrack(\.centerCoordinate) {
                CubicKeyframe(pubService.selectedPub?.coordinate ?? PubService.Constants.london,
                              duration: ((pubService.previousPub == nil) || (pubService.selectedPub == nil)) ? 1 : 6)
            }
            KeyframeTrack(\.distance) {
                if pubService.previousPub == nil {
                    CubicKeyframe(pubService.selectedPub == nil ? 12_000 : 4_000, duration: 1)
                } else if pubService.selectedPub == nil {
                    CubicKeyframe(12_000, duration: 1)
                } else {
                    CubicKeyframe(600, duration: 2)
                    LinearKeyframe(600, duration: 3)
                    SpringKeyframe(4_000, duration: 1)
                }
            }
            KeyframeTrack(\.pitch) {
                if pubService.previousPub != nil && pubService.selectedPub != nil {
                    LinearKeyframe(45, duration: 2.5)
                    LinearKeyframe(0, duration: 2.5)
                } else {
                    LinearKeyframe(0, duration: 1)
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
    
    @ViewBuilder
    private var backButton: some View {
        if pubService.selectedPub != nil {
            Button(action: {
                pubService.deselect()
            }, label: {
                ZStack {
                    Circle()
                        .foregroundStyle(.blue)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "arrow.backward")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            })
            .padding()
        }
    }
    
    @ViewBuilder
    private var lookAroundPreview: some View {
        if pubService.selectedPub != nil {
            LookAroundPreview(scene: $scene, allowsNavigation: true, badgePosition: .bottomTrailing)
                .frame(width: 180, height: 180)
                .clipShape(Circle())
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
