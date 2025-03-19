//
//  ContentView.swift
//  MapIsGood
//
//  Created by Jacob Bartlett on 18/03/2025.
//

import MapKit
import SwiftUI


// Circle line pub crawl:
// https://circlelinepubcrawl.co.uk 
struct Pub: Decodable {
    let stop: Int
    let pubName: String
    let station: String
    var coordinate: CLLocationCoordinate2D?
    var visited: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case stop
        case pubName
        case station
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

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 51.5066, longitude: -0.1237),
                  distance: 10_000,
                  heading: .zero)
    )
//    @State private var pubs: [Pub] = []
    @StateObject private var pubService = PubService()
    
    var body: some View {
        Map(position: $cameraPosition) {
            mapAnnotations
            
            //            MapPolygon(overlay(coordinate: coordinate))
        }
        .mapStyle(.imagery)
        .ignoresSafeArea()
//        .onAppear {
//            loadPubCrawl()
//        }
    }
    

    
    
    //        .sheet(isPresented: $isSheetPresented) {
    //               SearchSheet()
    //        }
    //    }
    //
    //    private func overlay(coordinate: CLLocationCoordinate2D) -> MKPolygon {
    //        let rectangle = rectangle(around: coordinate)
    //        return MKPolygon(coordinates: rectangle, count: rectangle.count)
    //    }
    
    private var mapAnnotations: some MapContent {
        ForEach(pubService.pubs.filter { $0.coordinate != nil }, id: \.station) { pub in
            
            // TODO: Add a toggle so I can check off the pubs! Put it in a sheet
            Annotation(pub.pubName, coordinate: pub.coordinate!) {
                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.orange)
                    
                    Image(systemName: "mug.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
//                FlightAnnotationView(flight: flight,
//                                     rotationAngle: rotationAngle,
//                                     color: userColor,
//                                     startTime: startTime)
            }
        }
    }
    
    //    @State private var scene: MKLookAroundScene?
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

//struct FlightAnnotationView: View {
//
//    let rotation: Double
//    let image: Image
//    let emoji: String?
//    let scale: Double
//    let color: Color
//    let startTime: Date
//
//    init(flight: Flight, rotationAngle: Angle, color: Color, startTime: Date) {
//        self.rotation = rotationAngle.degrees + (flight.true_track ?? 0)
//        self.image = flight.category.image
//        self.emoji = flight.category.emoji
//        let categoryScale = flight.category.scaling
//        let height = flight.geo_altitude ?? 0
//        let heightScale = min(2, max(4.7 - log10(height + 1), 0.7))
//        self.scale = categoryScale * heightScale
//        self.color = color
//        self.startTime = startTime
//    }
//
//    var body: some View {
//        TimelineView(.animation) { context in
//            aircraft
//                .foregroundColor(color)
//                .rotationEffect(.degrees(rotation))
//                .scaleEffect(scale)
//                .blur(radius: 0.5)
//                .crtScreenEffect(startTime: startTime)
//        }
//    }
//
//    @ViewBuilder
//    private var aircraft: some View {
//        if let emoji {
//            GeometryReader { geo in
//                Rectangle()
//                    .mask(
//                        Text(emoji)
//                            .font(.system(size: min(geo.size.width, geo.size.height)))
//                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//                    )
//            }
//
//        } else {
//            image
//        }
//    }
//}
//

#Preview {
    MapView()
}
