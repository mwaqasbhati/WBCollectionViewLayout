//
//  MovieItemsGridLayout.swift
//  TestProject
//
//  Created by Muhammad Waqas  on 3/06/18.
//  Copyright © 2018 Emaar . All rights reserved.

import UIKit

// MARK: - MBGridViewLayoutDelegate

public protocol WBGridViewLayoutDelegate: class {
    func colectionView(_ collectionView: UICollectionView, numberOfItemsInRow row: Int) -> CellLayout
    func colectionView(_ collectionView: UICollectionView, sizeOfItemInRow row: Int) -> CGSize?
}

// These Default methods will be used, if you will not implement Delegate Methods.

extension WBGridViewLayoutDelegate {
    func colectionView(_ collectionView: UICollectionView, numberOfItemsInRow row: Int) -> CellLayout {
        if row % 4 == 0 || row % 4 == 3 {
            return CellLayout.Two
        } else if row % 4 == 1 || row % 4 == 2 {
            if row % 2 == 0 {
                return CellLayout.ThreeRight
            }
            return CellLayout.ThreeLeft
        }
        return CellLayout.Two
    }
    func colectionView(_ collectionView: UICollectionView, sizeOfItemInRow row: Int) -> CGSize? {
        return nil
    }
}

// Enum for Defining Layout Direction and Layout Type
// MARK: - Layout - Enums

public enum CellLayout {
    case Two
    case ThreeLeft
    case ThreeRight
    
    var itemsCount: Int {
        switch self {
        case .Two: return 2
        case .ThreeLeft: return 3
        case .ThreeRight: return 3
        }
    }
}

// MARK: - Layout - Main Class

open class WBGridViewLayout: UICollectionViewLayout {
    
    // MARK: - Instances
    
    private var horizontalInset = 0.0 as CGFloat
    private var verticalInset = 0.0 as CGFloat
    private var itemHeightForTwoCell = 195.0 as CGFloat
    private var itemHeightForThreeCell = 330.0 as CGFloat
    
    private var _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    private var _contentSize = CGSize.zero
    
    private var layoutCell: CellLayout = .Two
    private var typeTotalItems = 0
    private var lastRowHeight = 0.0
    
    public weak var delegate: WBGridViewLayoutDelegate?
    
    private lazy var quarterWidth = {
        return (self.collectionView?.frame.size.width ?? 0.0) * 0.25
    }()
    private lazy var halfWidth = {
        return (self.collectionView?.frame.size.width ?? 0.0) * 0.50
    }()
    private lazy var threeQuarterWidth = {
        return (self.collectionView?.frame.size.width ?? 0.0) * 0.75
    }()
    
    private struct Numbers {
        static let One = 1
        static let Two = 2
        static let Three = 3
    }
    
    // MARK: -
    // MARK: - Layout
    
    override open func prepare() {
        super.prepare()
        
        if delegate == nil {
            fatalError("Please confirm to delegate to Continue")
        }
        _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
        drawLayout()
        
    }
    
    // MARK: -
    // MARK: - Initializers
    
    public init(horizontalInset: CGFloat = 0.0, verticalInset: CGFloat = 0.0) {
        self.horizontalInset = horizontalInset
        self.verticalInset = verticalInset
        super.init()
    }
    required public init?(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    // MARK: - Helpers
    
    private func drawLayout() {
        
        let path = IndexPath(item: 0, section: 0)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: path)
        
        let headerHeight = CGFloat(0.0)
        attributes.frame = CGRect(x: 0, y: 0, width: self.collectionView!.frame.size.width, height: headerHeight)
        
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        _layoutAttributes[headerKey] = attributes
        
        var yOffset = headerHeight

        let numberOfSections = self.collectionView!.numberOfSections
        
        for section in 0 ..< numberOfSections {
            
            let numberOfItems = self.collectionView!.numberOfItems(inSection: section)
            
            var xOffset = horizontalInset
            
            for item in 0 ..< numberOfItems {
                
                let indexPath = IndexPath(item: item, section: section)
                var attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if xOffset == horizontalInset  && typeTotalItems == 0 {
                    // This code will be used to reset some global variables when layout will switch from 2 to 3 cell and vice versa.
                    
                    guard let cellLayout = delegate?.colectionView(collectionView!, numberOfItemsInRow: indexPath.row) else {
                        fatalError("Number of Items not provided for Row \(indexPath.row)")
                    }
                    
                    layoutCell = cellLayout
                    typeTotalItems = layoutCell.itemsCount
                }
                // This code will be used to draw 2 and 3 cells in a box depending on layoutCell.
                switch layoutCell {
                case .Two:
                                drawTwoCellLayoutFor(indexPath: indexPath, attributes: &attributes, xOffset: &xOffset, yOffset: &yOffset)
                case .ThreeLeft:
                                drawThreeCellLeftLayoutFor(indexPath: indexPath, attributes: &attributes, xOffset: &xOffset, yOffset: &yOffset)
                case .ThreeRight:
                                drawThreeCellRightLayoutFor(indexPath: indexPath, attributes: &attributes, xOffset: &xOffset, yOffset: &yOffset)
                    
                }
            }
        }
        
        // This code will be used to add some extra padding at the bottom
        
        if typeTotalItems > 0 {
            let numberOfItems = self.collectionView!.numberOfItems(inSection: 0)
            let mItemSize = getItemSize(at: numberOfItems)
            yOffset += mItemSize.height
        }
        
        _contentSize = CGSize(width: self.collectionView!.frame.size.width, height: yOffset + self.verticalInset)
    
    }
    private func drawTwoCellLayoutFor(indexPath: IndexPath, attributes: inout UICollectionViewLayoutAttributes,xOffset: inout CGFloat, yOffset: inout CGFloat) {
        
        let mItemSize = getItemSize(at: indexPath.row)

        if typeTotalItems > 0 {
            attributes.frame = CGRect(x: xOffset, y: yOffset, width: mItemSize.width, height: mItemSize.height).integral
         //   print("Row: \(indexPath.row) Frame: \(attributes.frame)")
            let key = layoutKeyForIndexPath(indexPath)
            _layoutAttributes[key] = attributes // 7
            
            xOffset += mItemSize.width
            typeTotalItems -= 1
            if typeTotalItems == 0 {
                xOffset = horizontalInset
                yOffset += mItemSize.height
            }
        }
    }
    private func drawThreeCellLeftLayoutFor(indexPath: IndexPath, attributes: inout UICollectionViewLayoutAttributes,xOffset: inout CGFloat, yOffset: inout CGFloat) {
        
        var mItemSize = getItemSize(at: indexPath.row)

            if typeTotalItems > 0 {
                if typeTotalItems == Numbers.Three {
                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: mItemSize.width, height: mItemSize.height).integral
                    xOffset += mItemSize.width
                }
                else if typeTotalItems == Numbers.Two {
                    mItemSize.height = mItemSize.height/2
                    let itemWidth = (collectionView?.frame.size.width ?? 0.0) - mItemSize.width
                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: mItemSize.height).integral
                    yOffset += mItemSize.height
                }
                else if typeTotalItems == Numbers.One {
                    mItemSize.height = mItemSize.height/2
                    let itemWidth = (collectionView?.frame.size.width ?? 0.0) - mItemSize.width
                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: mItemSize.height).integral
                }
                
            //    print("Row: \(indexPath.row) Frame: \(attributes.frame)")
                let key = layoutKeyForIndexPath(indexPath)
                _layoutAttributes[key] = attributes // 7
                typeTotalItems -= 1
                
                if typeTotalItems == 0 {
                    //reset
                    xOffset = horizontalInset
                    yOffset += mItemSize.height
                }
                
            }
    }
    private func drawThreeCellRightLayoutFor(indexPath: IndexPath, attributes: inout UICollectionViewLayoutAttributes,xOffset: inout CGFloat, yOffset: inout CGFloat) {
        
        var mItemSize = getItemSize(at: indexPath.row)
        
        if typeTotalItems > 0 {

            if typeTotalItems == Numbers.Three {
                mItemSize.height = mItemSize.height/2
                let itemWidth = (collectionView?.frame.size.width ?? 0.0) - mItemSize.width
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: mItemSize.height).integral
                yOffset += mItemSize.height
            }
            else if typeTotalItems == Numbers.Two {
                mItemSize.height = mItemSize.height/2
                let itemWidth = (collectionView?.frame.size.width ?? 0.0) - mItemSize.width
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: mItemSize.height).integral
                yOffset += mItemSize.height
                xOffset += itemWidth
            }
            else if typeTotalItems == Numbers.One {
                yOffset -= mItemSize.height
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: mItemSize.width, height: mItemSize.height).integral
            }
            
         //   print("Row: \(indexPath.row) Frame: \(attributes.frame)")
            let key = layoutKeyForIndexPath(indexPath)
            _layoutAttributes[key] = attributes // 7
            typeTotalItems -= 1
            
            if typeTotalItems == 0 {
                //reset
                xOffset = horizontalInset
                yOffset += mItemSize.height
            }
            
        }
    }
    private func getItemSize(at row: Int) -> CGSize {
        guard let itemSize = delegate?.colectionView(collectionView!, sizeOfItemInRow: row) else {
            switch layoutCell {
            case .Two:
                return CGSize(width: halfWidth, height: itemHeightForTwoCell)
            case .ThreeLeft:
                return CGSize(width: threeQuarterWidth, height: itemHeightForThreeCell)
            case .ThreeRight:
                return CGSize(width: threeQuarterWidth, height: itemHeightForThreeCell)
            }
        }
        return itemSize
    }
    
    private func layoutKeyForIndexPath(_ indexPath : IndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    
    private func layoutKeyForHeaderAtIndexPath(_ indexPath : IndexPath) -> String {
        return "s_\(indexPath.section)_\(indexPath.row)"
    }
    
    // MARK: -
    // MARK: - Layout attributes
    
    override open var collectionViewContentSize: CGSize {
            return _contentSize
    }
    
    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            let headerKey = layoutKeyForIndexPath(indexPath)
            return _layoutAttributes[headerKey]
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            let key = layoutKeyForIndexPath(indexPath)
            return _layoutAttributes[key]
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
                let layoutAttribute = self._layoutAttributes[evaluatedObject as! String]
                return rect.intersects(layoutAttribute!.frame)
            }
            let dict = _layoutAttributes as NSDictionary
            let keys = dict.allKeys as NSArray
            let matchingKeys = keys.filtered(using: predicate)
            return dict.objects(forKeys: matchingKeys, notFoundMarker: NSNull()) as? [UICollectionViewLayoutAttributes]
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return !newBounds.size.equalTo(self.collectionView!.frame.size)
    }
}
