//
//  Collection Views.swift
//  Efficio
//
//  Created by Jake Casino on 7/6/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

public protocol UINestedCollectionView {
	var collectionView: UICollectionView! { get set }
}

extension UICollectionView {
	public convenience init(addTo view: UIView, sectionInset: UIEdgeInsets) {
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = sectionInset
		
		self.init(frame: .zero, collectionViewLayout: layout)
		view.addSubview(self)
		dataSource = view as? UICollectionViewDataSource
		delegate = view as? UICollectionViewDelegateFlowLayout
	}
}

extension UICollectionViewFlowLayout {
	public func addPadding(allAround value: CGFloat) {
		sectionInset = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
	}
	
	public func addPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
		sectionInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
}
