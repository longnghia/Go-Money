import Foundation

struct ServiceResources {
    static let exchangeUri = "https://api.apilayer.com/exchangerates_data/latest"
}

struct ExchangeResult: Codable {
    let base: String
    let date: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case base
        case date
        case rates
    }
}

typealias ExchangeCompletion = (Result<ExchangeResult, Error>) -> Void

class ExchangeService {
    let cache = URLCache.shared

    func getExchangeRate(from base: String, to: [CurrencyUnit], completion: @escaping ExchangeCompletion) {
        guard let url = URL(string: String(format: "%@?base=%@", ServiceResources.exchangeUri, base)) else { return }

        print("url=\(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("3NhHH9XmhDpxPSmVcPKU71r3S5BkDDX2", forHTTPHeaderField: "apikey")

        let reachable = ConnectionService.shared.isReachable

        print(reachable)

        if !reachable {
            let data = self.cache.cachedResponse(for: request)?.data
            print(data)

            if let data = data {
                do {
                    let rate = try JSONDecoder().decode(ExchangeResult.self, from: data)
                    completion(.success(rate))
                } catch {
                    completion(.failure(error))
                }
            }
        } else {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let data = data {
                        do {
                            let rate = try JSONDecoder().decode(ExchangeResult.self, from: data)

                            // cache response
                            if let response = response {
                                let cachedData = CachedURLResponse(response: response, data: data)
                                self.cache.storeCachedResponse(cachedData, for: request)
                            }

                            completion(.success(rate))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
