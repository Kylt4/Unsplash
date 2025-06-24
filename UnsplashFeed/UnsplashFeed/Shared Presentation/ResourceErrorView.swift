//	
// Copyright © 2020 Christophe Bugnon All rights reserved.
//

import Foundation

@MainActor
public protocol ResourceErrorView {
	func display(_ viewModel: ResourceErrorViewModel)
}
