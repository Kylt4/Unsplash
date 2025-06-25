//
//  Copyright © 2019 Christophe Bugnon All rights reserved.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
	private let session: URLSession
    private let apiKey: String

    public init(session: URLSession, apiKey: String) {
		self.session = session
        self.apiKey = apiKey
	}
	
	private struct UnexpectedValuesRepresentation: Error {}
	
	private struct URLSessionTaskWrapper: HTTPClientTask {
		let wrapped: URLSessionTask
		
		func cancel() {
			wrapped.cancel()
		}
	}
	
	public func get(from url: URL, completion: @escaping @Sendable (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey,
                         forHTTPHeaderField: "Authorization")
		let task = session.dataTask(with: request) { data, response, error in
			completion(Result {
				if let error = error {
					throw error
				} else if let data = data, let response = response as? HTTPURLResponse {
					return (data, response)
				} else {
					throw UnexpectedValuesRepresentation()
				}
			})
		}
		task.resume()
		return URLSessionTaskWrapper(wrapped: task)
	}
}

