//
//  ViewController.swift
//  InstaGrid
//
//  Created by Enzo Gammino on 25/04/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        didTapMiddleLayout()

    }
    
    @IBOutlet weak var addTopLeft: UIButton!
    @IBOutlet weak var addTopRight: UIButton!
    @IBOutlet weak var addBottomRight: UIButton!
    @IBOutlet weak var addBottomLeft: UIButton!
    
    @IBOutlet weak var photoMontageView: UIView!
    @IBOutlet weak var middleLayout: UIButton!
    @IBOutlet weak var leftLayout: UIButton!
    @IBOutlet weak var rightLayout: UIButton!
    
    
    @IBAction func didTapMiddleLayout() {
        middleLayout.isSelected = true
        leftLayout.isSelected = false
        rightLayout.isSelected = false
        middleLayout.setImage(UIImage(named: "Selected"), for: .selected)
        
        addTopRight.isHidden = false
        addBottomRight.isHidden = true
    }
    @IBAction func didTapLeftLayout() {
        middleLayout.isSelected = false
        leftLayout.isSelected = true
        rightLayout.isSelected = false
        leftLayout.setImage(UIImage(named: "Selected"), for: .selected)
        
        addTopRight.isHidden = true
        addBottomRight.isHidden = false
    }
    @IBAction func didTapRightLayout() {
        middleLayout.isSelected = false
        leftLayout.isSelected = false
        rightLayout.isSelected = true
        rightLayout.setImage(UIImage(named: "Selected"), for: .selected)
        
        addTopRight.isHidden = false
        addBottomRight.isHidden = false
    }
    
    
    @IBAction func addImageTopLeft() {
        addTopLeft.isSelected = true
        addTopLeft.setImage(UIImage(named: "IMG_2463"), for: .selected)
        
    }
//    @IBAction func addImageToRight() {
//    }
//    @IBAction func addImageBottomLeft() {
//    }
//    @IBAction func addImageBottomRight() {
//    }
}

