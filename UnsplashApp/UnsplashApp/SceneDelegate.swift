//
//  SceneDelegate.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 27/01/2023.
//

import UIKit
import Combine
import UnsplashFeed
import UnsplashFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var localImageLoader = LocalImageDataLoader()

    private lazy var scheduler = DispatchQueue(
        label: "com.christophebugnon.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    )

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral),
            apiKey: Secrets.apiKey
        )
    }()

    private lazy var mainViewController: UITabBarController = {
        let tabController = UITabBarController()
        UIKitNavigationController.tabBarItem = UITabBarItem(
            title: "UIKit",
            image: UIImage(systemName: "backward.fill"),
            tag: 0)
        swiftUINavigationController.tabBarItem = UITabBarItem(
            title: "SwiftUI",
            image: UIImage(systemName: "forward.fill"),
            tag: 1)
        tabController.viewControllers = [
            UIKitNavigationController,
            swiftUINavigationController
        ]
        return tabController
    }()

    private lazy var UIKitNavigationController = UINavigationController(rootViewController: UIKitFeedComposer.feedComposedWith(
        feedLoader: makeRemoteFeedLoader,
        imageLoader: makeLocalImageLoaderWithRemoteFallback,
        selection: select(image:)))

    private lazy var swiftUINavigationController = UINavigationController(
        rootViewController: SwiftUIFeedComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoader,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
            selection: selectSwiftUI(image:))
    )

    private let baseURL = URL(string: "https://api.unsplash.com/")!
    private var cancellable: Cancellable?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)

        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }

    private func selectSwiftUI(image: FeedImage) {
        self.swiftUINavigationController.pushViewController(
            SwiftUIProfileComposer.profileComposedWith(
                image: FeedImageToProfileImageMapper.map(image),
                userPhotosLoader: makeRemoteUserPhotosLoader(username:),
                imageLoader: makeLocalImageLoaderWithRemoteFallback(url:)),
            animated: true)
    }

    private func select(image: FeedImage) {
        self.UIKitNavigationController.pushViewController(
            UIKitProfileComposer.profileComposedWith(
                image: FeedImageToProfileImageMapper.map(image),
                userPhotosLoader: makeRemoteUserPhotosLoader(username:),
                imageLoader: makeLocalImageLoaderWithRemoteFallback(url:)),
            animated: true)
    }

    private func makeRemoteFeedLoader() -> AnyPublisher<Paginated<FeedImage>, Error> {
        return makeRemoteFeedLoader(page: 0)
    }

    private func makeRemoteFeedLoader(page: Int) -> AnyPublisher<Paginated<FeedImage>, Error> {
        let url = UnsplashFeedEndPoint.photos(page: page).url(baseURL: baseURL)
        return httpClient
            .getPublisher(url: url)
            .tryMap(FeedItemsMapper.map)
            .map(makeFirstPage)
            .eraseToAnyPublisher()
    }

    private func makeRemoteUserPhotosLoader(username: String) -> AnyPublisher<ProfileImagesItem, Error> {
        let url = UnsplashUserPhotosEndPoint.profile(username: username).url(baseURL: baseURL)
        return httpClient
            .getPublisher(url: url)
            .tryMap(UserPhotosMapper.map)
            .eraseToAnyPublisher()
    }

    private func makeFirstPage(items: [FeedImage]) -> Paginated<FeedImage> {
        makePage(items: items, page: 1)
    }

    private func makePage(items: [FeedImage], page: Int) -> Paginated<FeedImage> {
        Paginated(page: page,
                  items: items, loadMorePublisher: {
            self.makeRemoteLoadMoreLoader(page: page)
        })
    }

    private func makeRemoteLoadMoreLoader(page: Int) -> AnyPublisher<Paginated<FeedImage>, Error> {
        let nextPage = page + 1
        return makeRemoteFeedLoader(page: nextPage)
            .map { ($0.items, nextPage) }
            .map(makePage)
            .eraseToAnyPublisher()
    }

    private func makeRemoteImageLoader(url: URL) -> ImageDataLoader.Publisher {
        httpClient
            .getPublisher(url: url)
            .tryMap(FeedImageDataMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> ImageDataLoader.Publisher {
        let localImageLoader = localImageLoader

        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient, scheduler] in
                return httpClient
                    .getPublisher(url: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
