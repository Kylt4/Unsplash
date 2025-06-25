//
//  Copyright © 2020 Christophe Bugnon All rights reserved.
//

import Foundation
import Combine
import UnsplashFeed

public extension Paginated {
    init(page: Int, items: [Item], loadMorePublisher: (() -> AnyPublisher<Self, Error>)?) {
        self.init(index: page, items: items, loadMore: loadMorePublisher.map { publisher in
			return { completion in
				publisher().subscribe(Subscribers.Sink(receiveCompletion: { result in
					if case let .failure(error) = result {
						completion(.failure(error))
					}
				}, receiveValue: { result in
					completion(.success(result))
				}))
			}
		})
	}
	
	var loadMorePublisher: (() -> AnyPublisher<Self, Error>)? {
		guard let loadMore = loadMore else { return nil }
		
		return {
			Deferred {
				Future(loadMore)
			}.eraseToAnyPublisher()
		}
	}
}

public extension HTTPClient {
	typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
	
	func getPublisher(url: URL) -> Publisher {
		var task: HTTPClientTask?
		
		return Deferred {
			Future { completion in
                task = self.get(from: url, completion: SendableProxy.makeSendable(completion))
			}
		}
		.handleEvents(receiveCancel: { task?.cancel() })
		.eraseToAnyPublisher()
	}
}

public extension LocalImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Error>

    func loadImageDataPublisher(url: URL) -> Publisher {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.loadImageData(from: url)
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension LocalImageDataLoader {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        try? save(data, for: url)
    }
}

extension Publisher where Output == Data {
    func caching(to cache: LocalImageDataLoader, using url: URL) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { data in
            cache.saveIgnoringResult(data, for: url)
        }).eraseToAnyPublisher()
    }
}

public extension ImageDataLoader {
	typealias Publisher = AnyPublisher<Data, Error>
	
	func loadImageDataPublisher(from url: URL) -> Publisher {
		return Deferred {
			Future { completion in
				completion(Result {
					return try self.loadImageData(from: url)
				})
			}
		}
		.eraseToAnyPublisher()
	}
}

extension Publisher {
	func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
		self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
	}
}

extension Publisher {
	func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
		receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
	}
}

extension DispatchQueue {
	static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
		ImmediateWhenOnMainQueueScheduler.shared
	}
	
	struct ImmediateWhenOnMainQueueScheduler: Scheduler {
		typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
		typealias SchedulerOptions = DispatchQueue.SchedulerOptions
		
		var now: SchedulerTimeType {
			DispatchQueue.main.now
		}
		
		var minimumTolerance: SchedulerTimeType.Stride {
			DispatchQueue.main.minimumTolerance
		}
		
		static let shared = Self()
		
		private static let key = DispatchSpecificKey<UInt8>()
		private static let value = UInt8.max
		
		private init() {
			DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
		}
		
		private func isMainQueue() -> Bool {
			DispatchQueue.getSpecific(key: Self.key) == Self.value
		}
		
		func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
			guard isMainQueue() else {
				return DispatchQueue.main.schedule(options: options, action)
			}
			
			action()
		}
		
		func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
			DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
		}
		
		func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
			DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
		}
	}
}
