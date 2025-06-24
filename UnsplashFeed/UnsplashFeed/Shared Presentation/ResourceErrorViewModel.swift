//
//  Copyright © 2019 Christophe Bugnon All rights reserved.
//

public struct ResourceErrorViewModel {
	public let message: String?
	
	static var noError: ResourceErrorViewModel {
		return ResourceErrorViewModel(message: nil)
	}
	
	static func error(message: String) -> ResourceErrorViewModel {
		return ResourceErrorViewModel(message: message)
	}
}
