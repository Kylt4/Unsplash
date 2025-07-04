//
//  Copyright © 2019 Christophe Bugnon All rights reserved.
//

import Foundation

public protocol HTTPClientTask {
	func cancel()
}

public protocol HTTPClient {
	typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
	@discardableResult
	func get(from url: URL, completion: @escaping @Sendable (Result) -> Void) -> HTTPClientTask
}
