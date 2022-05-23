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
    
    private var swipeGesture: UISwipeGestureRecognizer?
    private var selectedPlusButton: UIButton?
    private var deviceOrientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(sharePhotoMontageView))
        guard let swipeGesture = swipeGesture else { return }
        photoMontageView.addGestureRecognizer(swipeGesture)
    }
    
    override func viewDidLayoutSubviews() {
        didChangeOrientation()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        didChangeOrientation()
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
        swipeView(didShare: true)
        shareController()
    }
    
    private func shareController() {
        let share = UIActivityViewController(activityItems: [imageRendering()], applicationActivities: nil)
        share.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                self.swipeView(didShare: false)
                self.photoMontageView.transform = .identity
            }
            self.swipeView(didShare: false)
            self.photoMontageView.transform = .identity
        }
        present(share, animated: true)
    }
    
    private func didChangeOrientation() {
        swipeGesture?.direction = deviceOrientation.isPortrait ? .up  : .left
    }
    
    private func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    private func swipeView(didShare: Bool) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var translationX: CGFloat
        var translationY: CGFloat
        translationX = didShare ? -screenWidth : 0
        translationY = didShare ? -screenHeight : 0
        var translationTransform: CGAffineTransform
        translationTransform = swipeGesture?.direction == .up ? CGAffineTransform(translationX: 0, y: translationY) : CGAffineTransform(translationX: translationX, y: 0)
        UIView.animate(withDuration: 0.3, animations: { self.photoMontageView.transform = translationTransform })
    }
    
    private func imageRendering() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: photoMontageView.bounds.size)
        let image = renderer.image { ctx in
            photoMontageView.drawHierarchy(in: photoMontageView.bounds, afterScreenUpdates: true)
        }
        return image
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

