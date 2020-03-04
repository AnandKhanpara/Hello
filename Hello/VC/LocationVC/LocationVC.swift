//
//  LocationVC.swift
//  Hello
//
//  Created by ZerOnes on 01/02/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import MapKit

protocol ShareLocationDelegate {
    func locationAddress(latitude:Double, longitude:Double, address:String)
}

class LocationVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblNVTitle: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var viewTopDividerLine: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Variable
    
    var isSetAddress = false
    var address:String = ""
    var coordinate = CLLocationCoordinate2D()
    var delegate:ShareLocationDelegate?
    var isShowLocation = false
    var personalMessage:PersonalMessage?
    var groupMessage:GroupMessage?
    var chatType:ChatType?
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillSetUp()
    }
    
    //MARK:- View SetUp
    
    func viewDidSetUp() {
        
        self.viewTopDividerLine.addGradiantLayer(GradiantColor.redBlue)
        
        if self.isShowLocation == true {
            
            var latitude = 0.0
            var longitude = 0.0
            var address = ""
            
            if self.chatType == .personal {
                latitude = self.personalMessage?.messageLatitudeDouble ?? 0
                longitude = self.personalMessage?.messageLongitudeDouble ?? 0
                address = self.personalMessage?.messageAddress ?? ""
            }else if self.chatType == .group {
                latitude = self.groupMessage?.messageLatitudeDouble ?? 0
                longitude = self.groupMessage?.messageLongitudeDouble ?? 0
                address = self.groupMessage?.messageAddress ?? ""
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = address
            self.mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            
            self.btnShare.isHidden = true
            
        }else {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.mapAnnotation_longGesture))
            longPress.delegate = self
            longPress.minimumPressDuration = 1
            self.mapView.addGestureRecognizer(longPress)
            
            self.btnShare.isHidden = false
        }
    }
    
    func viewWillSetUp() {
        
    }
    
    //MARK:- Action
    
    @IBAction func btnShareLocation_touchUpInside(_ sender: UIButton) {
        if self.isSetAddress == true {
            self.dismiss(animated: true) {
                self.delegate?.locationAddress(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude, address: self.address)
            }
        }
    }
    
    @IBAction func btnClose_touchUpInside(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK:- Function
    
    @objc func mapAnnotation_longGesture(gesture:UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.mapView.removeAnnotations( self.mapView.annotations)
            let location = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
            self.coordinate = coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            self.findAddressFromCoordinate(coordinate: coordinate)
        }
    }
    
    func findAddressFromCoordinate(coordinate:CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let arrAddress = placemarks?.first?.addressDictionary!["FormattedAddressLines"] as? [String] {
                let address = arrAddress.joined(separator: ", ")
                self.address = address
                self.isSetAddress = true
            }else {
                self.isSetAddress = false
            }
        }
    }
    
    //MARK:- Web Service
    
}

//MARK:- Extension
