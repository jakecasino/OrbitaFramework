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
	@IBOutlet var view: UIView!
	@IBOutlet public var micButton: MicButton!
	@IBOutlet public var delegate: ORBChatToolbarDelegate?
	private var listeningAnimation: ListeningAnimation!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		loadXib(forClass: ORBChatToolbar.self, named: "ChatToolbar")
		setupXibView(view, inContainer: self)
		
		listeningAnimation = ListeningAnimation(addTo: view)
		view.sendSubview(toBack: listeningAnimation)
		
		style(micButton, [.glyphEdgeInsets: 10])
		micButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleMic(_:))))
		
	}
	
	@objc func toggleMic(_ gesture: UITapGestureRecognizer) {
		micButton.toggle(inactiveState: {
			delegate?.chatToolbarMicDidExitListeningMode()
		}) {
			delegate?.chatToolbarMicDidEnterListeningMode()
		}
		
		listeningAnimation.toggle(isListening: micButton.isSelected)
	}
}

public class MicButton: UIAction {
	class sizes {
		class var minimized: CGFloat { return 44 }
		class var maximized: CGFloat { return 76 }
	}
}

private class ListeningAnimation: UIView {
	var speakerGrills = [UIView]()
	
	override func didMoveToSuperview() {
		guard let superview = superview else { error.thereWasNoSuperview(for: self); return }
		matchFrame(to: superview.bounds)
		
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
	
	func toggle(isListening: Bool) {
		guard let superview = superview else { error.thereWasNoSuperview(for: self); return }
		
		enum loops {
			case a
			case b
		}
		func startGrillAnimation(loop: loops, grill: UIView, delay: TimeInterval) {
			switch loop {
			case .a:
				UIView.animate(withDuration: 0.6, delay: delay, options: .curveLinear, animations: {
					grill.resize(width: nil, height: padding.extraLarge)
					grill.move(x: nil, y: origins.middle, considersSafeAreaFrom: self.superview!)
				}) { (_) in
					if isListening {
						startGrillAnimation(loop: .b, grill: grill, delay: 0)
					}
				}
				break
			case .b:
				UIView.animate(withDuration: 0.6, delay: delay, options: .curveLinear, animations: {
					grill.resize(width: nil, height: SpeakerGrill.height)
					grill.move(x: nil, y: origins.middle, considersSafeAreaFrom: self.superview!)
				}) { (_) in
					if isListening {
						startGrillAnimation(loop: .a, grill: grill, delay: 0)
					}
				}
			}
		}
		
		switch isListening {
		case true:
			for grill in speakerGrills {
				addSubview(grill)
				grill.move(x: origins.center, y: origins.middle, considersSafeAreaFrom: superview)
				
				let delay = Double.random(in: 0...1)
				startGrillAnimation(loop: .a, grill: grill, delay: delay)
			}
			
			UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations: {
				/*
				self.resize(width: nil, height: 196)
				self.move(x: nil, y: origins.bottom)
				
				if let parent = self.parent as? MainViewController {
					parent.conversationThread.sizeToFitConversation()
				}
				*/
				
			}, completion: { (_) in
				
				/*
				let sentence = demo.dictation.components(separatedBy: " ")
				let dictationView = UILabel(frame: CGRect.zero)
				self.view.addSubview(dictationView)
				dictationView.resizeTo(width: self.view.bounds.width - (spacing(.large) * 2), height: 100)
				dictationView.move(x: origins.center, y: origins.top)
				dictationView.numberOfLines = 0
				dictationView.textAlignment = .center
				dictationView.text = ""
				
				for (delay, word) in sentence.enumerated() {
					DispatchQueue.main.asyncAfter(deadline: .now() + (Double(delay) * 0.3)) {
						dictationView.text! += (word + " ")
					}
				}
				*/
			})
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
			})
			break
		case false:
			/*
			view.subviews.forEach { (view) in
				if view is UILabel { view.removeFromSuperview() }
			}
			
			UIView.animate(withDuration: 0.15) {
				self.view.setFrame(equalTo: self.toolbar)
				self.view.move(x: nil, y: origins.bottom)
				self.toolbar.move(x: nil, y: origins.bottom)
			}
			*/
			
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
				for grill in self.speakerGrills {
					grill.resize(width: SpeakerGrill.width, height: SpeakerGrill.height)
					grill.move(x: origins.center, y: origins.middle, considersSafeAreaFrom: superview)
				}
			}) { (_) in
				self.speakerGrills.forEach({ $0.removeFromSuperview() })
			}
			break
		}
	}
}

private class SpeakerGrill {
	static var width: CGFloat { return 4 }
	static var spacing: CGFloat { return padding.small }
	static var height: CGFloat { return padding.small }
}
