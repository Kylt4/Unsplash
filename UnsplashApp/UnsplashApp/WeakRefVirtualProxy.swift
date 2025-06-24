//
//  Copyright © 2019 Christophe Bugnon All rights reserved.
//

import UIKit
import UnsplashFeed
import UnsplashFeediOS

class WeakRefVirtualProxy<T: AnyObject> {
	weak var object: T?

	init(_ object: T) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: ResourceErrorView where T: ResourceErrorView {
	func display(_ viewModel: ResourceErrorViewModel) {
		object?.display(viewModel)
	}
}

extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
	func display(_ viewModel: ResourceLoadingViewModel) {
		object?.display(viewModel)
	}
}

class ImageWeakRefVirtualProxy<T: ResourceView & AnyObject>: WeakRefVirtualProxy<T>, ResourceView where T.ResourceViewModel == UIImage {
    func display(_ viewModel: UIImage) {
        object?.display(viewModel)
    }
}

class ProfileImagesWeakRefVirtualProxy<T: ResourceView & AnyObject>: WeakRefVirtualProxy<T>, ResourceView where T.ResourceViewModel == ProfileImagesViewModel {
    func display(_ viewModel: ProfileImagesViewModel) {
        object?.display(viewModel)
    }
}

class ProfileImagesStateWeakRefVirtualProxy<T: ResourceView & AnyObject>: WeakRefVirtualProxy<T>, ResourceView where T.ResourceViewModel == ProfileImageStateContainer {
    func display(_ viewModel: ProfileImageStateContainer) {
        object?.display(viewModel)
    }
}
