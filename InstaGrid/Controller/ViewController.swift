//
//  ViewController.swift
//  InstaGrid
//
//  Created by Enzo Gammino on 25/04/2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var topRightGridButton: UIButton!
    @IBOutlet weak var bottomRightGridButton: UIButton!
    @IBOutlet weak var photoMontageView: UIView!
    @IBOutlet var layoutButtons: [UIButton]!
    
    // MARK: - Properties
    
    var selectedPlusButton: UIButton?
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
    var direction : UISwipeGestureRecognizer.Direction?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(sharePhotoMontageView))
        photoMontageView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
            
            coordinator.animate(alongsideTransition: { (context) in
                guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
                
                if windowInterfaceOrientation.isLandscape {
                    print("Interface orientation is now = Landscape")
                    self.direction = .left
                    // activate landscape changes
                } else {
                    print("Interface orientation is now = Portrait")
                    self.direction = .up
                    // activate portrait changes
                }
            })
        }
        

    // MARK: - Actions
    
    
    @IBAction func layoutButtonTapped(_ sender: UIButton) {
        layoutButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        switch sender.tag {
        case 0:
            topRightGridButton.isHidden = true
            bottomRightGridButton.isHidden = false
        case 1:
            topRightGridButton.isHidden = false
            bottomRightGridButton.isHidden = true
        case 2:
            topRightGridButton.isHidden = false
            bottomRightGridButton.isHidden = false
        default: break
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton){
        selectedPlusButton = sender
        showImagePickerController()
    }
    
    @objc func sharePhotoMontageView(_ sender: UISwipeGestureRecognizer) {
        sender.direction = direction ?? .up
        print(sender.direction.rawValue == 4 ? "Up" : "Left") /* 1 = | 2 = Left | 4 = Up | 8 = Down */
//        swipeView()
    }
    
    private func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    func swipeView() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var translationTransform: CGAffineTransform
        if UIDevice.current.orientation.isPortrait == true {
            translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight)
        }
        else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        UIView.animate(withDuration: 0.3, animations: {self.photoMontageView.transform = translationTransform })
    }
}

// MARK: - Extensions

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedPlusButton?.setImage(editedImage, for: .normal)
            selectedPlusButton?.subviews.first?.contentMode = .scaleAspectFill
        }
        dismiss(animated: true)
    }
}

