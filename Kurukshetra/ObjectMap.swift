import Foundation

typealias Welcome = [WelcomeElement]

struct WelcomeElement: Codable {
    let ownerName: String
    let gameName, date: String
    let result: String
    let team: [String: [String]]
    
    enum CodingKeys: String, CodingKey {
        case ownerName, gameName, date, result
        case team = "Team"
    }
}

enum Result: String, Codable {
    case nA = "N/A"
}
func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<Welcome: Codable>(with url: URL, completionHandler: @escaping (Welcome?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil , response, error)
                return
            }
            completionHandler(try! newJSONDecoder().decode(Welcome.self, from: data), response, nil)
        }
    }
    
    func welcomeTask(with url: URL, completionHandler: @escaping (Welcome?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
