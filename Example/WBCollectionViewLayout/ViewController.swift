//
//  ViewController.swift
//  CustomLayout
//
//  Created by Muhammad Waqas Bhati on 3/21/18.
//  Copyright © 2018 Muhammad Waqas Bhati. All rights reserved.
//

import UIKit
import WBCollectionViewLayout

enum MyCellLayout: Int {
    case Two = 2
    case ThreeLeft = 3
    case ThreeRight = 4
    case Mixture = 5
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellLayout: MyCellLayout = .Mixture
    
    var items: [Int] {
        var temp = [Int]()
        for i in 1..<103 {
            temp.append(i)
        }
        return temp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = WBGridViewLayout()
        layout.delegate = self
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as? CustomCell
        let item = items[indexPath.row]
        cell?.titleLbl.text = "\(item)"
        cell?.layer.borderColor = UIColor.black.cgColor
        cell?.layer.borderWidth = 2.0
        return cell!
        
    }

}

extension ViewController: WBGridViewLayoutDelegate {

    func colectionView(_ collectionView: UICollectionView, numberOfItemsInRow row: Int) -> CellLayout {
        switch cellLayout {
        case .Two: return .Two
        case .ThreeLeft: return .ThreeLeft
        case .ThreeRight: return .ThreeRight
        case .Mixture:
            if row % 4 == 1 || row % 4 == 2 {
                if row % 2 == 0 {
                    return .ThreeRight
                }
                return .ThreeLeft
            }
        }
        return CellLayout.Two
    }
    func colectionView(_ collectionView: UICollectionView, sizeOfItemInRow row: Int) -> CGSize? {
         return nil
    }
    
}

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
}
