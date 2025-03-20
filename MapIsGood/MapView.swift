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
            circleLine
        }
        .mapStyle(.hybrid)
        .ignoresSafeArea()
    }
    
    
    
    
    //        .sheet(isPresented: $isSheetPresented) {
    //               SearchSheet()
    //        }
    //    }
    
    private var circleLine: MapPolyline {
        MapPolyline(
            MKPolyline(coordinates: pubService.pubs.compactMap(\.coordinate),
                       count: pubService.pubs.count)
        )
    }
    
    private var mapAnnotations: some MapContent {
        ForEach(pubService.pubs.filter { $0.coordinate != nil }, id: \.station) { pub in
            // TODO: Add a toggle so I can check off the pubs! Put it in a sheet
            Annotation("\(pub.stop): \(pub.pubName)", coordinate: pub.coordinate!) {
                PubAnnotationView(pub: pub)
            }
        }
    }
    
    //
    //    .onChange(of: selectedLocation) {
    //        if let selectedLocation {
    //            Task {
    //                scene = try? await fetchScene(for: selectedLocation.location)
    //            }
    //        }
    //        isSheetPresented = selectedLocation == nil
    //    }
    //    .overlay(alignment: .bottom) {
    //        if selectedLocation != nil {
    //            LookAroundPreview(scene: $scene, allowsNavigation: false, badgePosition: .bottomTrailing)
    //                .frame(height: 150)
    //                .clipShape(RoundedRectangle(cornerRadius: 12))
    //                .safeAreaPadding(.bottom, 40)
    //                .padding(.horizontal, 20)
    //        }
    //    }
    //
    //    private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
    //        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
    //        return try await lookAroundScene.scene
    //    }
}

struct PubAnnotationView: View {
    
    let pub: Pub
    
    init(pub: Pub) {
        self.pub = pub
    }
    
    var body: some View {
        Circle()
            .frame(width: 40, height: 40)
            .foregroundStyle(.orange)
            .mask(Image(systemName: "mug.fill").font(.headline))
            .blendMode(.difference)
    }
}

#Preview {
    MapView()
}
