//
//  Copyright © 2019 Christophe Bugnon All rights reserved.
//

import UIKit
import UnsplashFeed
import UnsplashFeediOS

final class FeedViewAdapter: ResourceView {
	private weak var controller: ListViewController?
	private let imageLoader: (URL) -> ImageDataLoader.Publisher
	private let selection: (FeedImage) -> Void
	private let currentFeed: [FeedImage: CellController]
    private let orderedItems: [FeedImage]

	private typealias FeedImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, ImageWeakRefVirtualProxy<FeedImageCellController>>
    private typealias ProfileImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, ImageWeakRefVirtualProxy<FeedProfileImageCellController>>
	private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
	
    init(currentFeed: [FeedImage: CellController] = [:], orderedItems: [FeedImage] = [], controller: ListViewController, imageLoader: @escaping (URL) -> ImageDataLoader.Publisher, selection: @escaping (FeedImage) -> Void) {
		self.currentFeed = currentFeed
        self.orderedItems = orderedItems
		self.controller = controller
		self.imageLoader = imageLoader
		self.selection = selection
	}
	
	func display(_ viewModel: Paginated<FeedImage>) {
		guard let controller = controller else { return }
		
		var currentFeed = self.currentFeed
        let feedItems = [orderedItems + viewModel.items].flatMap { $0 }
        let feed: [CellController] = feedItems.map { model in
			if let controller = currentFeed[model] {
				return controller
			}
			
			let feedImageAdapter = FeedImageDataPresentationAdapter(loader: { [imageLoader] in
				imageLoader(model.imageURL)
			})

            let profileImageAdapter = ProfileImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.profile.imageURL)
            })

            let composer = FeedCellControllerDelegateComposer(objects: [feedImageAdapter, profileImageAdapter])

			let view = FeedImageCellController(
				viewModel: FeedImagePresenter.map(model),
				delegate: composer,
				selection: { [selection] in
					selection(model)
				})

            let profileView = view.profileImageController
			
            feedImageAdapter.presenter = LoadResourcePresenter(
				resourceView: ImageWeakRefVirtualProxy(view),
				loadingView: WeakRefVirtualProxy(view),
				errorView: WeakRefVirtualProxy(view),
				mapper: UIImage.tryMake)

            profileImageAdapter.presenter = LoadResourcePresenter(
                resourceView: ImageWeakRefVirtualProxy(profileView),
                loadingView: WeakRefVirtualProxy(profileView),
                errorView: WeakRefVirtualProxy(profileView),
                mapper: UIImage.tryMake(data:))

			let controller = CellController(id: model, view)
			currentFeed[model] = controller
			return controller
		}
		
		guard let loadMorePublisher = viewModel.loadMorePublisher else {
			controller.display(feed)
			return
		}
		
		let loadMoreAdapter = LoadMorePresentationAdapter(loader: loadMorePublisher)
		let loadMore = LoadMoreCellController(callback: loadMoreAdapter.loadResource)
		
		loadMoreAdapter.presenter = LoadResourcePresenter(
			resourceView: FeedViewAdapter(
				currentFeed: currentFeed,
                orderedItems: feedItems,
				controller: controller,
				imageLoader: imageLoader,
				selection: selection
			),
			loadingView: WeakRefVirtualProxy(loadMore),
			errorView: WeakRefVirtualProxy(loadMore))
		
		let loadMoreSection = [CellController(id: UUID(), loadMore)]
		
		controller.display(feed, loadMoreSection)
	}
}
