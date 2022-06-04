//
//  DriverDetailsViewController.swift
//  AplMobile
//
//  Created by Claudia Apostol on 12.05.2022.
//

import UIKit
import SafariServices

class DriverDetailsViewController: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var driverToDisplay: FavDriver?
    
    @IBOutlet weak var permanentNumberLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.text = driverToDisplay?.name
        nationalityLabel.text = "Nationality: \(driverToDisplay?.nationality ?? "")"
        birthdayLabel.text = "Date of Birth: \(driverToDisplay?.dateOfBirth ?? "")"
        permanentNumberLabel.text = "Permanent number: \(driverToDisplay?.permanentNumber ?? "")"
    }
    
    @IBAction func didPressCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didPressLinkButton(_ sender: Any) {
        setupWebView()
    }
    
    @IBAction func didPressShareButton(_ sender: Any) {
        guard let firstName = driverToDisplay?.name else {
            return
        }
        let text = "Check out \(firstName)"
        
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func setupWebView() {
        let safariVC = SFSafariViewController(url: URL(string: driverToDisplay?.url ?? "")! as URL)
           self.present(safariVC, animated: true, completion: nil)
           safariVC.delegate = self
    }
}

extension DriverDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DriverImageCollectionViewCell", for: indexPath) as! DriverImageCollectionViewCell
        cell.imageSlide.image = UIImage(named: "\(driverToDisplay?.code ?? "")\(indexPath.row+1)")
        
        return cell
    }
}

extension DriverDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds
        return CGSize(width: size.width, height: size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
