//	
// Copyright © 2020 Christophe Bugnon All rights reserved.
//

import Foundation

@MainActor
public protocol ResourceLoadingView {
	func display(_ viewModel: ResourceLoadingViewModel)
}
