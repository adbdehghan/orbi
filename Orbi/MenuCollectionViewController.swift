//
//  MenuCollectionViewController.swift
//  Orbi
//
//  Created by adb on 6/8/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MenuCollectionViewController: UICollectionViewController {
    
    var menuImages = ["asset_drive","help","setting"]
    var menuNames = ["Drive","Help","Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let image = cell.contentView.viewWithTag(10)! as! UIImageView
        let containerView = cell.contentView.viewWithTag(22)!
        let menuNameLabel = cell.contentView.viewWithTag(44)! as! UILabel
        menuNameLabel.font = UIFont(name: "Vazir-Medium", size: 20)
        menuNameLabel.text = menuNames[indexPath.item]

        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        image.image = UIImage(named: menuImages[indexPath.item])
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if BleSingleton.shared.bleManager.connectedDevice != nil
            {
                self.performSegue(withIdentifier: "drive", sender: self)
            }
            else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let connectController = storyBoard.instantiateViewController(withIdentifier: "connectViewController") as! ConnectViewController
                self.present(connectController, animated: true, completion: nil)
            }
        case 1:
            self.performSegue(withIdentifier: "help", sender: self)
        case 2:
            self.performSegue(withIdentifier: "setting", sender: self)
        default:
            self.performSegue(withIdentifier: "connection", sender: self)
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            if let currentFocused = (self.collectionView?.collectionViewLayout as? FocusedContaining)?.currentInFocus {
                let indexPath = IndexPath(item: currentFocused, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            }
            self.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
}

