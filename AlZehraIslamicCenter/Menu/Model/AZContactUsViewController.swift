//
//  AZContactUsViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 28/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import MessageUI
import CoreLocation

enum Location {
    case startLocation
    case endLocation
}

class AZContactUsViewController: UIViewController, CLLocationManagerDelegate {
    
//    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var contactNumber: UIButton!
    @IBOutlet weak var email: UIButton!
    var locationManager:CLLocationManager!
    
//    var locationSelected = Location.startLocation
//
    var userLocation = CLLocation()
//    var endLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startMonitoringSignificantLocationChanges()
//
//        let camera = GMSCameraPosition.camera(withLatitude: 33.487007, longitude: -117.143784, zoom: 15.0)
//
//        self.googleMapView.camera = camera
//        self.googleMapView.delegate = self
//        self.googleMapView.isMyLocationEnabled = true
//        self.googleMapView.settings.myLocationButton = true
//        self.googleMapView.settings.compassButton = true
//        self.googleMapView.settings.zoomGestures = true

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Contact"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        self.userLocation = userLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
//    func createMarker(title: String, icon: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
//        marker.title = title
//        marker.icon = icon
//        marker.map = self.googleMapView
//    }
    
    @IBAction func socialSiteTapped(sender: UIButton) {
        if sender.tag == 0 {
            self.openContactDetail(url: "https://www.youtube.com/channel/UCWnnYaxN4BFvZTlgKrQDoXA")
        } else if sender.tag == 1 {
            self.openContactDetail(url: "https://www.facebook.com/groups/140000089352849/?fref=nf")
        } else if sender.tag == 2 {
            self.openContactDetail(url: "https://www.instagram.com/al_zahra_islamic_center_nc/")
        }
    }
    
    @IBAction func callAction(sender: UIButton) {
        guard let number = URL(string: "tel://+17045611667") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func sendEmailAction(sender: UIButton) {
        let mailComposerVC = self.configureMailController(emailID: (email.titleLabel?.text)!)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showEmailError()
        }
    }
    
    func configureMailController(emailID: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([emailID])
        mailComposerVC.setSubject("Al Zahra User")
        mailComposerVC.setMessageBody("Your Feedback is always welcome.", isHTML: false)
        return mailComposerVC
    }
    
    func showEmailError() {
        AZUtility.showAlert(title: "Could not send email", message: "Your device could not send email", actionTitles: "OK", actions: nil)
    }
    
    
    
    func openContactDetail(url: String) {
        let wkViewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .wkViewController) as? AZWKViewController
        wkViewController?.urlStr = url
        self.navigationController?.pushViewController(wkViewController!, animated: true)
    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func showDirection(_ sender: UIButton) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            // use bellow line for specific source location
            let destination = CLLocationCoordinate2D(latitude: 35.190728, longitude: -80.774007)
            let urlString = "http://maps.google.com/?saddr=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&daddr=\(destination.latitude),\(destination.longitude)&directionsmode=driving"
            
            UIApplication.shared.openURL(URL(string: urlString)!)
        } else
        {
            NSLog("Can't use com.google.maps://");
        }
    }
}

extension AZContactUsViewController: ViewController {
    
    func updateView() {}
}

//extension AZContactUsViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//
//        let endLocation = CLLocation(latitude: 35.227085, longitude: -80.843124)
//
//        createMarker(title: "Masjid", icon: #imageLiteral(resourceName: "Annotation"), latitude: endLocation.coordinate.latitude, longitude: endLocation.coordinate.longitude)
//        createMarker(title: "Your Location", icon: #imageLiteral(resourceName: "Annotation"), latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
//
//        self.drawPath(startLocation: location!, endLocation: endLocation)
//        self.locationManager.stopUpdatingLocation()
//    }
//
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        self.googleMapView.isMyLocationEnabled = true
//    }
//
//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        self.googleMapView.isMyLocationEnabled = true
//        if gesture {
//            mapView.selectedMarker = nil
//        }
//    }
//
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//
//        self.googleMapView.isMyLocationEnabled = true
//        return false
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        print("Cordinates: \(coordinate)")
//    }
//
//    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//        self.googleMapView.isMyLocationEnabled = true
//        self.googleMapView.selectedMarker = nil
//        return false
//    }
//
//    @IBAction func showDirection(_ sender: UIButton) {
//        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
//        {
//            UIApplication.shared.openURL(NSURL(string:
//                "comgooglemaps://?saddr=&daddr=\(Float(28.38)),\(Float(77.12))&directionsmode=driving")! as URL)
//        } else
//        {
//            NSLog("Can't use com.google.maps://");
//        }
//    }
//}

extension AZContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue :
            print("Cancelled")
            
        case MFMailComposeResult.failed.rawValue :
            AZUtility.showAlert(title: "Email", message: "Failed to send email", actionTitles: "OK", actions: nil)
            print("Failed")
            
        case MFMailComposeResult.saved.rawValue :
            AZUtility.showAlert(title: "Email", message: "Email is saved", actionTitles: "OK", actions: nil)
            print("Saved")
            
        case MFMailComposeResult.sent.rawValue :
            AZUtility.showAlert(title: "Email", message: "Your email is sent successfully", actionTitles: "OK", actions: nil)
            print("Sent")
            
            
            
        default: break
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
