//
//  mapVC.swift
//  OrderDrink
//
//  Created by  明智 on 2020/1/3.
//  Copyright © 2020 ming. All rights reserved.
//

import UIKit
import MapKit
class mapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var ann_shopLoaction = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        setMapRegion()
    }
    

    @IBAction func backToPosition(_ sender: Any) {
    setMapRegion()
    }
    
    func setMapRegion(){
        let location = CLLocationCoordinate2D(latitude: 24.143188, longitude: 120.675741)
        let ann = MKPointAnnotation()
        ann.coordinate = location
        ann.title = "綜合飲料店"
        ann.subtitle = "歡迎光臨"
        let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(ann)
        mapView.isZoomEnabled = true
    }
    

}
