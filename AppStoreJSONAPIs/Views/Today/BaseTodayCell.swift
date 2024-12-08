//
//  BaseTodayCell.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 18/11/24.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {
    
    var todayItem: TodayItem!
    
    override var isHighlighted: Bool{ //a collectionView property
        didSet{
            var transform: CGAffineTransform = .identity
            if isHighlighted{
                transform = .init(scaleX: 0.9, y: 0.9)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut, animations: {
                self.transform = transform
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundView = UIView()
        addSubview(self.backgroundView!)
        self.backgroundView?.fillSuperview()
        self.backgroundView?.backgroundColor = .systemBackground //have to set bgColor to show shadows
        self.backgroundView?.layer.cornerRadius = 16
        self.backgroundView?.layer.shouldRasterize = true //smooths frames, makes images as bitmap, but lowers quality
        
        //cell shadow
//        self.backgroundView?.layer.shadowOpacity = 0.1 //using shadows generally slows down the device
//        self.backgroundView?.layer.shadowRadius = 10
//        self.backgroundView?.layer.shadowOffset = .init(width: 0, height: 10) // shifts shadow
        
        updateShadow()//initial setup
    }
    
    @objc func updateShadow() {
            // Check the current interface style
            if traitCollection.userInterfaceStyle == .dark {
                // Shadows for dark mode (lighter glow effect)
                self.backgroundView?.layer.shadowOpacity = 0.2
                self.backgroundView?.layer.shadowRadius = 15
                self.backgroundView?.layer.shadowOffset = .init(width: 0, height: 10)
                self.backgroundView?.layer.shadowColor = UIColor.white.cgColor
            } else {
                // Shadows for light mode (default)
                self.backgroundView?.layer.shadowOpacity = 0.2
                self.backgroundView?.layer.shadowRadius = 10
                self.backgroundView?.layer.shadowOffset = .init(width: 0, height: 10)
                self.backgroundView?.layer.shadowColor = UIColor.black.cgColor
            }
        }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Only update if the interface style has changed
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateShadow()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
