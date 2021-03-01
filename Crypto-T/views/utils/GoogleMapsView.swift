//
//  GoogleMapsView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 01.03.2021.
//

import SwiftUI
import GoogleMaps


struct GoogleMapsView: UIViewRepresentable {
    
    @EnvironmentObject var session: Session
    
    @Binding var assistant: GoogleMapsAssistant
    
    func makeCoordinator() -> GoogleMapsViewCoordinator {
        return GoogleMapsViewCoordinator(assistant: $assistant)
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        assistant.position = camera.target
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Update markers
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.latitude)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
    }
}

class GoogleMapsViewCoordinator: NSObject, GMSMapViewDelegate {
    
    @Binding var assistant: GoogleMapsAssistant
    
    init(assistant: Binding<GoogleMapsAssistant>) {
        self._assistant = assistant
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        assistant.position = position.target
    }
}
