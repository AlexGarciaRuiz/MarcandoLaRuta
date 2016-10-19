//
//  ViewController.swift
//  MarcandoLaRuta
//
//  Created by AlexGarcia on 10/17/16.
//  Copyright © 2016 AlexGarcia. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    
    var lastLocation: CLLocation? = nil
    var startLocation: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        
        manejador.requestWhenInUseAuthorization()
        
        mapa.mapType = MKMapType.standard
        //print("Span-info")
        //print(String(format: "%.2f",mapa.region.span.latitudeDelta) + ", " + String(format: "%.2f",mapa.region.span.longitudeDelta))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func mapTypeChange(_ sender: UISegmentedControl) {
        mapa.mapType = MKMapType(rawValue: UInt(sender.selectedSegmentIndex))!
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            //print("Inicia actualizacion Localizacion")
        }
        else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation: CLLocation = locations[0]
        var deltaLatitude: CLLocationDegrees = mapa.region.span.latitudeDelta
        var deltaLongitude: CLLocationDegrees = mapa.region.span.longitudeDelta
        
        if lastLocation == nil {
            startLocation = myLocation
            lastLocation = myLocation
            deltaLatitude = 0.01
            deltaLongitude = 0.01
        }
        
        let distancia = myLocation.distance(from: lastLocation!)
        
        if distancia > 50 {
            var punto = CLLocationCoordinate2D()
            punto.latitude = myLocation.coordinate.latitude
            punto.longitude = myLocation.coordinate.longitude
            
            let pin = MKPointAnnotation()
            let distanciaTotal = myLocation.distance(from: startLocation!)
            
            pin.title = String(format: "%.4f",punto.latitude) + ", " +
                String(format: "%.4f",punto.longitude)
            pin.subtitle = String(format: "%.2f",distanciaTotal)
            pin.coordinate = punto
            
            mapa.addAnnotation(pin)

            lastLocation = myLocation
        }
        
        let latitude: CLLocationDegrees = myLocation.coordinate.latitude
        let longitude: CLLocationDegrees = myLocation.coordinate.longitude
        //let deltaLatitude: CLLocationDegrees = 0.01
        //let deltaLongitude: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake(deltaLatitude, deltaLongitude)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        mapa.setRegion(region, animated: true)
        
    }

    
    @IBAction func zoomOutAction(_ sender: UIButton) {
        var theRegion = mapa.region;
        
        // Zoom out
        theRegion.span.latitudeDelta /= 2.0;
        theRegion.span.longitudeDelta /= 2.0;
        mapa.setRegion(theRegion, animated: true)
        //print(String(format: "%.2f",theRegion.span.latitudeDelta) + ", " + String(format: "%.2f",theRegion.span.longitudeDelta))
    }
    
    @IBAction func zoomInAction(_ sender: AnyObject) {
        var theRegion = mapa.region;
        
        // Zoom In
        theRegion.span.latitudeDelta *= 2.0;
        theRegion.span.longitudeDelta *= 2.0;
        mapa.setRegion(theRegion, animated: true)
        //print(String(format: "%.2f",theRegion.span.latitudeDelta) + ", " + String(format: "%.2f",theRegion.span.longitudeDelta))
    }
    
    
}

