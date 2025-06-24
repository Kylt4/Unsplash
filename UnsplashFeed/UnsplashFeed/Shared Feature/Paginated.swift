//	
// Copyright © 2020 Christophe Bugnon All rights reserved.
//

import Foundation

public struct Paginated<Item> {
	public typealias LoadMoreCompletion = (Result<Self, Error>) -> Void

    public let index: Int
	public let items: [Item]
	public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
	
    public init(index: Int, items: [Item], loadMore: ((@escaping LoadMoreCompletion) -> Void)? = nil) {
        self.index = index
		self.items = items
		self.loadMore = loadMore
	}
}
