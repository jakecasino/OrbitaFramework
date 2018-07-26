//
//  Strings.swift
//  Efficio
//
//  Created by Jake Casino on 7/7/18.
//

extension UILabel {
	
	public convenience init(addTo view: UIView) {
		self.init(frame: .zero)
		view.addSubview(self)
	}
	
	public convenience init(addTo view: UIView?, text TEXT: String, font FONT: UIFont, constrainWidthTo constrainedWidth: CGFloat, numberOfLines NUMBEROFLINES: Int) {
		if let view = view { self.init(addTo: view) }
		else { self.init() }
		font = FONT
		text = TEXT
		numberOfLines = NUMBEROFLINES
		lineBreakMode = .byTruncatingTail
		resize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude)
		sizeToFit()
	}
	
	public static func estimateHeight(withNumberOfLines numberOfLines: Int, text: String, constrainWidthTo constrainedWidth: CGFloat, font: UIFont) -> CGFloat {
		let label = UILabel()
		label.numberOfLines = numberOfLines
		label.frame.size = CGSize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude)
		label.lineBreakMode = .byWordWrapping
		label.text = text
		label.sizeToFit()
		
		return label.frame.height
	}
	
	public static func estimateHeight(text: String, constrainWidthTo constrainedWidth: CGFloat, font: UIFont) -> CGFloat {
		let size = CGSize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedStringKey: font], context: nil)
		
		return estimatedFrame.height
	}
}

extension String {
	public static var someLongGenericText: String { return "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent rutrum enim nisi, sed feugiat est molestie imperdiet. Praesent sed lacinia felis. Etiam at luctus erat, viverra accumsan risus. Nulla facilisi. Donec venenatis tempus volutpat. Donec nibh lacus, rhoncus quis odio eu, finibus pellentesque arcu. Aenean eu varius nisl, ac pulvinar libero. Cras nec placerat libero. Suspendisse pellentesque tempor sapien, quis aliquet enim accumsan quis. Suspendisse non erat eget quam dignissim lobortis. Nunc imperdiet libero nec tortor malesuada, eu pulvinar mauris venenatis. Nunc consectetur mi vitae rutrum vulputate. Nam sit amet tincidunt lorem." }
}
