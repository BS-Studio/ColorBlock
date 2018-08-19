//
//  ViewController.swift
//  OutfitBlock
//
//  Created by Ri Zhao on 2018-08-04.
//  Copyright © 2018 Ri Zhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let slider = ColorScrubber(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(slider)
    }

    override func viewDidLayoutSubviews() {
        let width: CGFloat = 300.0
        let margin: CGFloat = view.bounds.width/2 - (width/2)
        slider.frame = CGRect(x: margin, y: margin, width: width, height: 600)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

