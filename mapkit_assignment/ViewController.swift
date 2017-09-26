//
//  ViewController.swift
//  mapkit_assignment
//
//  Created by Amit Rajoria on 9/25/17.
//  Copyright © 2017 Amit Rajoria. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var sourceView: UIView!
    
    @IBOutlet weak var destView: UIView!
    
    @IBOutlet weak var sourceAddress: UITextField!
    
    @IBOutlet weak var sourceCity: UITextField!

    @IBOutlet weak var sourceState: UITextField!
    
    @IBOutlet weak var sourceZip: UITextField!
    
    @IBOutlet weak var destAddress: UITextField!
    
    @IBOutlet weak var destCity: UITextField!
    
    @IBOutlet weak var destState: UITextField!
    
    @IBOutlet weak var destZip: UITextField!
    
    @IBOutlet weak var mapBtn: UIButton!
    
    @IBOutlet weak var routeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBorder() {
        sourceView.layer.borderWidth = 1
        sourceView.layer.borderColor = UIColor.white.cgColor
        destView.layer.borderWidth = 1
        destView.layer.borderColor = UIColor.white.cgColor
        mapBtn.layer.borderWidth = 1
        mapBtn.layer.borderColor = UIColor.white.cgColor
        routeBtn.layer.borderWidth = 1
        routeBtn.layer.borderColor = UIColor.white.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let source = sourceAddress.text! + ", " + sourceCity.text! + ", " + sourceCity.text! + ", " + sourceZip.text! + ", USA"
        
        let dest = destAddress.text! + ", " + destCity.text! + ", " + destState.text! + ", " + destZip.text! + ", USA"
        
        if let destinationVC = segue.destination as? LocationController {
            destinationVC.source = source
            destinationVC.dest = dest
            if segue.identifier == "showMap" {
                destinationVC.showType = "map"
            } else if segue.identifier == "showRoute" {
                destinationVC.showType = "route"
            }
        }
    }
}
