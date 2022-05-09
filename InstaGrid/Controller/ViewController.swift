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
    
    var imageButton: UIButton!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sharePhotoMontageView))
        photoMontageView.addGestureRecognizer(panGestureRecognizer)
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
        imageButton = sender
        showImagePickerController()
    }
    
    @objc func sharePhotoMontageView(_ sender: UIPanGestureRecognizer) {
        transformPhotoMontageView(gesture: sender)
//        guard let image = UIImage(named: "Selected") else { return }
//        let sharePhotoMontage = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        switch sender.state {
        case .changed:
            let _ = ""
//            present(sharePhotoMontage, animated: true, completion: nil)
        case .cancelled, .ended:
            swipeView()
//            if sharePhotoMontage.userActivity?.activityType == nil { photoMontageView.transform = .identity }
        default: break
        }
    }
    
    private func transformPhotoMontageView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: photoMontageView)
        if UIDevice.current.orientation.isPortrait == true {
            if translation.y <= 0 {
            let translationTransform = CGAffineTransform(translationX: 0, y: translation.y)
            photoMontageView.transform = translationTransform
            }
        }
        else {
            if translation.x <= 0 {
            let translationTransform = CGAffineTransform(translationX: translation.x, y: 0)
            photoMontageView.transform = translationTransform
            }
        }
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
        UIView.animate(withDuration: 0.3, animations: {self.photoMontageView.transform = translationTransform }, completion: nil)
    }
    
    @IBAction func dotIdentityTapped(_ sender: UIButton) { //ONLY FOR TEST
        photoMontageView.transform = .identity
    }
}

// MARK: - Extensions

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage, for: .normal)
            imageButton.subviews.first?.contentMode = .scaleAspectFill
        }
        else if let editedImage = info[.editedImage] as? UIImage {
            imageButton.setImage(editedImage, for: .normal)
            imageButton.subviews.first?.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
}

