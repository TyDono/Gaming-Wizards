//
//  MapViewController.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 12/5/22.
//

import SwiftUI
import MapboxMaps

struct MapBoxMapView: UIViewControllerRepresentable {
     
    func makeUIViewController(context: Context) -> MapViewController {
           return MapViewController()
       }
      
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    }
}


class MapViewController: UIViewController {
   internal var mapView: MapView!
//   override public func viewDidLoad() {
//       super.viewDidLoad()
//       let myResourceOptions = ResourceOptions(accessToken: "sk.eyJ1IjoidHlkb25vY29kZSIsImEiOiJjbGF3NnY4cnowMHpsM3ZtcjZwN2RlcGZoIn0.eBJZSDrPpHXQw5Ev3WozcQ")
//       let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 40.83647410051574,
//                                                                        longitude: 14.30582273457794), zoom: 4.5)
//       
//       let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions,
//                                             cameraOptions: cameraOptions,
//                                             styleURI: StyleURI(rawValue: "mapbox://styles/tydonocode/clbaxpp9k000015qjsk5jyous"))
//       
//       mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
//       mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//       self.view.addSubview(mapView)
//   }
}
