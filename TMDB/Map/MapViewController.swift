//
//  MapViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/11.
//
//import CoreLocation
import MapKit
import UIKit


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegion(center: center)
        
        setAnnotations(cinemaType: CinemaType.all)
    }
    
    private func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    private func setAnnotations(cinemaType: CinemaType) {
        removeAllAnnotations()
        
//        let coordinates = CinemaList.mapAnnotations.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
//
//        for coordinate in coordinates {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
////            annotation.title =
//        }
        
//        for cinema in CinemaList.mapAnnotations {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: cinema.latitude, longitude: cinema.longitude)
//            annotation.title = cinema.location
//
//            mapView.addAnnotation(annotation)
//        }
        
        var cinemas: [Cinema]
        
        if cinemaType == .all {
            cinemas = CinemaList.mapAnnotations
        } else {
            cinemas = CinemaList.mapAnnotations.filter { $0.type == cinemaType.rawValue }
        }
        
        for cinema in cinemas {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: cinema.latitude, longitude: cinema.longitude)
            annotation.title = cinema.location
            
            mapView.addAnnotation(annotation)
        }
        
    }
    
    
    private func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    
    private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
//        let megabox = UIAlertAction(title: CinemaType.????????????.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: CinemaType(rawValue: title!)!)  // ???? title ????????? ??? ??????????
//        }
//
//        let lotteCinema = UIAlertAction(title: CinemaType.???????????????.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: CinemaType(rawValue: self.title!)!)
//        }
//
//        let cgv = UIAlertAction(title: CinemaType.CGV.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: CinemaType(rawValue: self.title!)!)
//        }
//
//        let seeAll = UIAlertAction(title: CinemaType.all.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: CinemaType(rawValue: self.title!)!)
//        }
        
//        let megabox = UIAlertAction(title: CinemaType.????????????.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: .????????????)
//        }
//
//        let lotteCinema = UIAlertAction(title: CinemaType.???????????????.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: .???????????????)
//        }
//
//        let cgv = UIAlertAction(title: CinemaType.CGV.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: .CGV)
//        }
//
//        let seeAll = UIAlertAction(title: CinemaType.all.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: .all)
//        }
        
        for type in CinemaType.allCases {
            let action = UIAlertAction(title: type.rawValue, style: .default) { _ in
                self.setAnnotations(cinemaType: type)
            }
            
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "??????", style: .cancel) { _ in
//            self.removeAllAnnotations()
        }
    
//        alert.addAction(megabox)
//        alert.addAction(lotteCinema)
//        alert.addAction(cgv)
//        alert.addAction(seeAll)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    
    @IBAction func filterBarButtonClicked(_ sender: UIBarButtonItem) {
        showActionSheet()
    }
}


// ?????? ?????? ?????????
extension MapViewController {
    // iOS ?????? ????????? ????????? ?????? ??????
    private func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        // Location Manager??? authorization status
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
            print("????", authorizationStatus.rawValue)
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS ?????? ????????? ????????? ?????? ??????: locationServicesEnabled()
        if CLLocationManager.locationServicesEnabled() {
            // ?????? ?????? ?????? ??????
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("?????? ???????????? ?????????????????? ????????????. ?????? ???????????? ??? ?????????.")  // ???? ?????? ???????????? ???????????? ??????
        }
    }
    
    
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
            case .notDetermined:
                print("Not Determined")  // ???? iOS 14 ????????? ?????? ????????? ??????
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Restricted")
            case .denied:
                print("Denied")  // ???? ???????????? ??????
            case .authorizedWhenInUse:
                print("When in Use")  // ???? ?????? ?????? ??????
                locationManager.startUpdatingLocation()
//            case .authorizedAlways:
//            case .authorized:  // Deprecated
            default: print("Default")
        }
    }
}


extension MapViewController: CLLocationManagerDelegate {
    // iOS 14 ??????: ???????????? ?????? ?????? ????????? ????????? ???, ?????? ?????????(locationManager)??? ????????? ??? ?????????
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    
    // iOS 14 ??????
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            setRegion(center: coordinate)  // ???? ??????????????? ????????? ?????? ??????
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)  // ???? ?????? ?????????
    }
}
