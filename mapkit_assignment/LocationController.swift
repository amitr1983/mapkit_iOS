//
//  LocationController.swift
//  mapkit_assignment
//
//  Created by Amit Rajoria on 9/25/17.
//  Copyright © 2017 Amit Rajoria. All rights reserved.
//

import UIKit
import MapKit

class LocationController: UIViewController, MKMapViewDelegate{
    
     let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!

    var source: String = ""
    var dest: String = ""
    var showType = ""
    var geocoder = CLGeocoder()
    var places = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true;
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        if (!source.isEmpty) {
            places.append(source)
        }
        if (!dest.isEmpty) {
            places.append(dest)
        }
        if showType == "map" {
            displayRoute(places: places, polyline: false)
        } else if showType == "route" {
            displayRoute(places: places, polyline: true)
        }
    }
    
    func displayRoute(places:[String], polyline:Bool) {
        var i = 1
        var coordinates: CLLocationCoordinate2D?
        var placemark: CLPlacemark?
        var annotation: Station?
        var stations:Array = [Station]()
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for address in places {
            geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil)  {
                    print("Error", error!)
                }
                placemark = placemarks?.first
                if placemark != nil {
                    coordinates = placemark!.location!.coordinate
                    points.append(coordinates!)
                    annotation = Station(latitude: coordinates!.latitude, longitude: coordinates!.longitude, address: address)
                    stations.append(annotation!)
                    
                    if (i == self.places.count) {

                        self.mapView.addAnnotations(stations)
                        
                        if (polyline == true) {
                            print("Draw Stephen!!!")
                            let request = MKDirectionsRequest()
                            request.source = MKMapItem(placemark: MKPlacemark(coordinate: points[0], addressDictionary: nil))
                            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: points[1], addressDictionary: nil))
                            request.requestsAlternateRoutes = true
                            request.transportType = .automobile
                            
                            let directions = MKDirections(request: request)
                            
                            directions.calculate { [unowned self] response, error in
                                guard let unwrappedResponse = response else { return }
                                
                                if (unwrappedResponse.routes.count > 0) {
                                    self.mapView.add(unwrappedResponse.routes[0].polyline)
                                    self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
                                }
                            }
                        }
                    }
                    i += 1
                }
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.purple
            polylineRenderer.lineWidth = 6
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    class Station: NSObject, MKAnnotation {
        var title: String?
        var latitude: Double
        var longitude:Double
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        init(latitude: Double, longitude: Double, address: String) {
            self.latitude = latitude
            self.longitude = longitude
            self.title = address
        }
    }
}
