//
//  HttpHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-17.
//


import Foundation

enum EndPoint: String {
    case config = "config"
    case healthChecks = "healthchecks"
    case userLink = "users/:id/link"
}

class HttpHelper {
    private static let baseURLString = "http://localhost:8000/v1/"
    private static let username = Store.getStr("AppUserName")
    private static let password = Store.getStr("AppUserPassword")

    static var getConfigURL: URL {
        let components = URLComponents(string: "\(baseURLString)\(EndPoint.config.rawValue)")!
        return components.url!
    }

    static func getAuthHeader () -> String {
        let username = Store.getStr("AppUserName")
        let password = Store.getStr("AppUserPassword")
        let rawAuthHeader = "\(username):\(password)"
        let base64Auth = Data(rawAuthHeader.utf8).base64EncodedString()
        return "Basic \(base64Auth)"
    }

    static func getUserLinkURL (_ installId: String) -> URL {
        let url = "\(baseURLString)\(EndPoint.userLink.rawValue)"
        let newString = url.replacingOccurrences(of: ":id", with: installId)
        let components = URLComponents(string: newString)!
        return components.url!
    }

    struct Config: Codable {
        var id: String
        var secret: String
    }

    struct UserLink: Codable {
        var id: String
    }

    struct LinkRequestBody: Codable {
        var external_id: String
    }

    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    static func config(fromJSON data: Data) -> Result<Config, Error> {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Config.self, from: data)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }

    static func processConfigRequest(data: Data?,
                                      error: Error?) -> Result<Config, Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }

        return config(fromJSON: jsonData)
    }

    static func userLink(fromJSON data: Data) -> Result<UserLink, Error> {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(UserLink.self, from: data)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }

    static func processUserLinkRequest(data: Data?,
                                      error: Error?) -> Result<UserLink, Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }

        return userLink(fromJSON: jsonData)
    }

    static func fetchConfig(completion: @escaping (Result<Config, Error>) -> Void) {
        let url = self.getConfigURL
        var request = URLRequest(url: url)
        request.setValue(getAuthHeader(), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.processConfigRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }

    static func linkUser(_ installId: String, completion: @escaping (Result<UserLink, Error>) -> Void) {
        let url = self.getUserLinkURL(installId)
        var request = URLRequest(url: url)
        let userLinkBody = LinkRequestBody(external_id: username)

        do {
            let jsonData = try JSONEncoder().encode(userLinkBody)
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue(getAuthHeader(), forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = session.dataTask(with: request) {
                (data, response, error) in
                let result = self.processUserLinkRequest(data: data, error: error)
                completion(result)
            }
            task.resume()
        } catch let jsonErr{
            print(jsonErr)
       }
    }
}
