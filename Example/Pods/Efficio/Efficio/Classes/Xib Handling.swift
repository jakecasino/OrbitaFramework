//
//  Xib Handling.swift
//  Efficio
//
//  Created by Jake Casino on 7/20/18.
//

extension UIView {
	public func loadXib(named name: String) {
		Bundle.main.loadNibNamed(name, owner: self, options: nil)
	}
	
	public func loadXib(forClass anyClass: AnyClass, named name: String) {
		let bundle = Bundle(for: anyClass)
		bundle.loadNibNamed(name, owner: self, options: nil)
	}
	
	public func setupXibView(_ view: UIView, inContainer container: UIView) {
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.translatesAutoresizingMaskIntoConstraints = true
		view.matchFrame(to: container.bounds)
		addSubview(view)
		clipsToBounds = true
	}
}
