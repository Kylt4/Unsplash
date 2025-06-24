//
//  Copyright © 2019 Christophe Bugnon All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
		let identifier = String(describing: T.self)
		return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
	}
}
