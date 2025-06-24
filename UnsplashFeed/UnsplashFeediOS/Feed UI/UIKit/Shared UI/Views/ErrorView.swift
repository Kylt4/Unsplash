//
//  Copyright © 2019 Christophe Bugnon All rights reserved.
//

import UIKit

public final class ErrorView: UIButton {
	public var message: String? {
		get { return isVisible ? title(for: .normal) : nil }
		set { setMessageAnimated(newValue) }
	}
	
    public var onShow: (() -> Void)?
    public var onHide: (() -> Void)?

	public override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func configure() {
		backgroundColor = .errorBackgroundColor
		
		addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
		configureLabel()
		hideMessage()
	}
	
	private func configureLabel() {
		titleLabel?.textColor = .white
		titleLabel?.textAlignment = .center
		titleLabel?.numberOfLines = 0
		titleLabel?.font = .preferredFont(forTextStyle: .body)
		titleLabel?.adjustsFontForContentSizeCategory = true
	}
	
	private var isVisible: Bool {
		return alpha > 0
	}
	
    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            self.showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }
	
	private func showAnimated(_ message: String) {
		setTitle(message, for: .normal)
		contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

		UIView.animate(withDuration: 0.25) {
			self.alpha = 1
		}
        onShow?()
	}
	
	@objc private func hideMessageAnimated() {
		UIView.animate(
			withDuration: 0.25,
			animations: { self.alpha = 0 },
			completion: { completed in
				if completed { self.hideMessage() }
			})
	}
	
	private func hideMessage() {
		setTitle(nil, for: .normal)
		alpha = 0
		let height = bounds.height
		contentEdgeInsets = .init(top: -height/2, left: 0, bottom: -height/2, right: 0)
		onHide?()
	}
}

extension UIColor {
	static var errorBackgroundColor: UIColor {
		UIColor(red: 255/255, green: 106/255, blue: 105/255, alpha: 1)
	}
}
