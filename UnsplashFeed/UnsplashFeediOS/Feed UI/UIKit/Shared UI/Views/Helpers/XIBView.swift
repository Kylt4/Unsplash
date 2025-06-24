//
//  XIBView.swift
//  UnsplashFeediOS
//
//  Created by Christophe on 11/07/2023.
//

import UIKit

class XIBView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let view = Bundle(for: Self.self).loadNibNamed(String(describing: Self.self), owner: self, options: nil)!.first as! UIView
        view.fillView(self)
    }
}

private extension UIView {
    func fillView(_ container: UIView) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
