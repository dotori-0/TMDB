//
//  MapViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/11.
//
//import CoreLocation
import MapKit
import UIKit
import SwiftUI

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegion(center: center)
        
        setAnnotations(cinemaType: CinemaType.all)
    }
    
    func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func setAnnotations(cinemaType: CinemaType) {
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
    
    
    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    
    func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
//        let megabox = UIAlertAction(title: CinemaType.메가박스.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: CinemaType(rawValue: title!)!)  // 🍒 title 활용할 수 없을지?
//        }
//
//        let lotteCinema = UIAlertAction(title: CinemaType.롯데시네마.rawValue, style: .default) { _ in
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
        
//        let megabox = UIAlertAction(title: CinemaType.메가박스.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: .메가박스)
//        }
//
//        let lotteCinema = UIAlertAction(title: CinemaType.롯데시네마.rawValue, style: .default) { _ in
//            self.setAnnotations(cinemaType: .롯데시네마)
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
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
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


// 위치 관련 메서드
extension MapViewController {
    // iOS 위치 서비스 활성화 여부 확인
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        // Location Manager의 authorization status
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
            print("🍋", authorizationStatus.rawValue)
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 확인: locationServicesEnabled()
        if CLLocationManager.locationServicesEnabled() {
            // 위치 권한 종류 확인
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 비활성화되어 있습니다. 위치 서비스를 켜 주세요.")  // 🍒 얼럿 띄우거나 설정으로 이동
        }
    }
    
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
            case .notDetermined:
                print("Not Determined")  // 🍒 iOS 14 정확한 위치
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Restricted")
            case .denied:
                print("denied")  // 🍒 설정으로 유도
            case .authorizedWhenInUse:
                print("When in Use")  // 🍒 startUpdatingLocation()  // 🍒 항상 허용 요청
                locationManager.startUpdatingLocation()
//            case .authorizedAlways:
//            case .authorized:  // Deprecated
            default: print("Default")
        }
    }
}


extension MapViewController: CLLocationManagerDelegate {
    // iOS 14 이상: 사용자의 권한 부여 상태가 변경될 때, 위치 관리자(locationManager)가 생성될 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            setRegion(center: coordinate)  // 🍒 현재위치도 지도에 보여 주기
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)  // 🍒 얼럿 띄우기
    }

}
