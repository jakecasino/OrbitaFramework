//
//  ChatToolbar.swift
//  FBSnapshotTestCase
//
//  Created by Jake Casino on 7/24/18.
//

import Efficio

@objc public protocol ORBChatToolbarDelegate {
	func chatToolbarMicDidEnterListeningMode()
	func chatToolbarMicDidExitListeningMode()
}

public class ORBChatToolbar: UIView {
	@IBOutlet private var view: UIView!
	@IBOutlet public var delegate: ORBChatToolbarDelegate?
	private var needsToSetupAutoLayoutAlignment = true
	
	@IBOutlet private var micButton: MicButton!
	@IBOutlet weak var keyboardButton: UIAction!
	@IBOutlet weak var moreButton: UIAction!
	
	private var listeningAnimation: ListeningAnimation!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		loadXib(forClass: ORBChatToolbar.self, named: "ChatToolbar")
		setupXibView(view, inContainer: self)
		
		style(micButton, [.glyphEdgeInsets: 10])
		micButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleMic(_:))))
	}
	
	public override func didMoveToSuperview() {
		listeningAnimation = ListeningAnimation(addTo: view, linkToMicButton: micButton)
	}
	
	public func setupAutoLayoutAlignment(in view: UIView) {
		if needsToSetupAutoLayoutAlignment {
			if #available(iOS 11.0, *) {
				listeningAnimation.resize(addToWidth: nil, addToHeight: -(view.safeAreaInsets.bottom))
				needsToSetupAutoLayoutAlignment = false
			}
		}
	}
	
	public func changeMicButtonAppearance(newBackgroundColor: UIColor?, newGlyphNamed newGlyphName: String?) {
		if let newBackgroundColor = newBackgroundColor { style(micButton, [.backgroundColor: newBackgroundColor]) }
		if let newGlyphName = newGlyphName {
			if let glyphImage = UIImage(named: newGlyphName) {
				style(micButton, [.glyph: glyphImage])
			}
		}
	}
	
	@objc private func toggleMic(_ gesture: UITapGestureRecognizer) {
		micButton.toggle(inactiveState: {
			delegate?.chatToolbarMicDidExitListeningMode()
			
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
				self.micButton.transform = self.micButton.transform.scaledBy(x: 5/3, y: 5/3)
			})
			
			UIView.animate(withDuration: 0.85, animations: {
				self.style(self.keyboardButton, [.opacity: 1])
				self.style(self.moreButton, [.opacity: 1])
			}, completion: { (_) in
				self.keyboardButton.isUserInteractionEnabled = true
				self.moreButton.isUserInteractionEnabled = true
			})
		}) {
			delegate?.chatToolbarMicDidEnterListeningMode()
			
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
				self.micButton.transform = self.micButton.transform.scaledBy(x: 0.6, y: 0.6)
			})
			
			UIView.animate(withDuration: 0.15, animations: {
				self.style(self.keyboardButton, [.opacity: 0])
				self.style(self.moreButton, [.opacity: 0])
			}, completion: { (_) in
				self.keyboardButton.isUserInteractionEnabled = false
				self.moreButton.isUserInteractionEnabled = false
			})
		}
		
		listeningAnimation.toggle(isListening: micButton.isSelected)
	}
}

public class MicButton: UIAction {
	class sizes {
		class var minimized: CGFloat { return 76 * 0.6 }
		class var maximized: CGFloat { return 76 }
	}
}

private class ListeningAnimation: UIView {
	private var speakerGrills = [UIView]()
	private enum loops { case a; case b }
	private var isListening = false
	private var micButton: MicButton!
	
	fileprivate convenience init(addTo view: UIView, linkToMicButton MIC_BUTTON: MicButton) {
		self.init(frame: .zero)
		view.insertSubview(self, at: 0)
		micButton = MIC_BUTTON
		
		let numberOfGrills: Int
		let estimatedNumberOfGrills = Int((((bounds.width - MicButton.sizes.minimized) / 2) - padding.extraLarge) / (SpeakerGrill.width + SpeakerGrill.spacing)) * 2
		if (estimatedNumberOfGrills % 2) == 0 {
			numberOfGrills = estimatedNumberOfGrills
		} else {
			numberOfGrills = estimatedNumberOfGrills - 1
		}
		for _ in 1...numberOfGrills {
			let grill = UIView(frame: CGRect.zero)
			grill.resize(width: SpeakerGrill.width, height: SpeakerGrill.height)
			style(grill, [.backgroundColor: UIColor.orbitaBlue, .corners: corners.roundByWidth])
			speakerGrills.append(grill)
		}
	}
	
	override func didMoveToSuperview() {
		guard let superview = superview else { error.thereWasNoSuperview(for: self); return }
		matchFrame(to: superview.bounds)
	}
	
	func toggle(isListening IS_LISTENING: Bool) {
		isListening = IS_LISTENING
		
		switch isListening {
		case true:
			for grill in speakerGrills {
				addSubview(grill)
				grill.move(x: origins.center, y: origins.middle)
				
				let delay = Double.random(in: 0...1)
				
				startGrillAnimation(loop: .a, grill: grill, delay: delay)
			}
			
			micButton.isUserInteractionEnabled = false
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
				
				for (index, grill) in self.speakerGrills.enumerated() {
					if index < (self.speakerGrills.count / 2) {
						let x = ((self.bounds.width - MicButton.sizes.minimized) / 2) - ((SpeakerGrill.width + SpeakerGrill.spacing) * CGFloat(index + 1))
						grill.move(x: x, y: nil)
					} else {
						let x = ((self.bounds.width + MicButton.sizes.minimized) / 2) + ((SpeakerGrill.width + SpeakerGrill.spacing) * CGFloat((index - (self.speakerGrills.count / 2)) + 1))
						grill.move(x: x, y: nil)
					}
				}
			}, completion: { (_) in
				self.micButton.isUserInteractionEnabled = true
			})
			
			break
		
		case false:
			micButton.isUserInteractionEnabled = false
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
				for grill in self.speakerGrills {
					grill.resize(width: SpeakerGrill.width, height: SpeakerGrill.height)
					grill.move(x: origins.center, y: origins.middle)
				}
			}) { (_) in
				self.speakerGrills.forEach({ $0.removeFromSuperview() })
				self.micButton.isUserInteractionEnabled = true
			}
			
			break
		}
	}
	
	private func startGrillAnimation(loop: loops, grill: UIView, delay: TimeInterval) {
		switch loop {
		case .a:
			UIView.animate(withDuration: 0.6, delay: delay, options: .curveLinear, animations: {
				grill.resize(width: nil, height: padding.extraLarge)
				grill.move(x: nil, y: origins.middle)
			}) { (_) in
				if self.isListening { self.startGrillAnimation(loop: .b, grill: grill, delay: 0) }
			}
			break
		case .b:
			UIView.animate(withDuration: 0.6, delay: delay, options: .curveLinear, animations: {
				grill.resize(width: nil, height: SpeakerGrill.height)
				grill.move(x: nil, y: origins.middle)
			}) { (_) in
				if self.isListening { self.startGrillAnimation(loop: .a, grill: grill, delay: 0) }
			}
		}
	}
	
	private class SpeakerGrill {
		static var width: CGFloat { return 4 }
		static var spacing: CGFloat { return padding.small }
		static var height: CGFloat { return padding.small }
	}
}
