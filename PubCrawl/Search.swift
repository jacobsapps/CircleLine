//
//  Search.swift
//  MapIsGood
//
//  Created by Jacob Bartlett on 18/03/2025.
//

import Combine
import Foundation
import SwiftUI
import MapKit


// TODO: This needs to be 2 services. The pub service and a ton of separate completers that can run in parallel. Maybe this is an actor?
class PubService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {

    @Published var pubs: [Pub] = []
    @Published var selectedPub: Pub?
    static let shared = PubService()
    
    private var completer = MKLocalSearchCompleter()
    
    
    override init() {
        super.init()
        
        completer.delegate = self
        completer.resultTypes = .address
        
        loadPubCrawl()
    }
    
    private func loadPubCrawl() {
        let url = Bundle.main.url(forResource: "pubs", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        pubs = try! JSONDecoder().decode([Pub].self, from: data)
        print(pubs)
        for pub in pubs.shuffled() {
            let address = "\(pub.address)"
            print(address)
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                
                print(placemarks?.first, error)
                guard let coordinate = placemarks?.first?.location?.coordinate else {
                    print("No results for \(pub.pubName)")
                    return
                }
                print(coordinate)
                Task { @MainActor in
                    if let index = self.pubs.firstIndex(where: { $0.stop == pub.stop }) {
                        self.pubs[index].coordinate = coordinate
                    }
                }
            }
        }
    }
    
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        if let pub = completer.results.first {
//            selectCompletion(pub)
//        }
//    }
//    
//    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        print(completer)
//        print("Error searching: \(error.localizedDescription)")
//    }
//    
//    func selectCompletion(_ completion: MKLocalSearchCompletion) {
//        print(completion)
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = completion.title
//        
//        let search = MKLocalSearch(request: request)
//        search.start { response, error in
//            print(response)
//            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
//            print(coordinate)
//            print()
////            DispatchQueue.main.async {
////                self.selectedLocation = coordinate
////            }
//        }
//    }
}
