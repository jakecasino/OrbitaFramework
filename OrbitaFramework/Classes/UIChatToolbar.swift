//
//  ChatToolbar.swift
//  FBSnapshotTestCase
//
//  Created by Jake Casino on 7/24/18.
//

import Efficio

class UIChatToolbar: UIView {
	@IBOutlet var view: UIView!
	@IBOutlet var micButton: UIAction!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		loadXib(forClass: UIChatToolbar.self, named: "UIChatToolbar")
		setupXibView(view, inContainer: self)
		
		style(micButton, [.glyphEdgeInsets: 10])
	}
}
