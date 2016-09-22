//
//  BusinessAnnotation.swift
//  Chozen
//
//  Created by HamiltonMac on 9/19/16.
//  Copyright © 2016 HamiltonMac. All rights reserved.
//

import Foundation
import MapKit

let busAddress = ["12661 W Lake Houston Pkwy","9525 North Sam Houston Pkwy"]
let busName = ["Starbucks","Chik-fil-a"]

class BusinessAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    //var businessNumber: Int
    var businessName: String
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, businessName: String) {
        self.coordinate = coordinate
        //self.businessNumber = businessNumber
        self.businessName = businessName
        self.title = self.businessName
    }
}
