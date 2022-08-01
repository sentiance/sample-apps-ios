//
//  AuthCodeAPI.swift
//  sample_app_ios
//
//  Created by Jozef Sako on 24/06/2022.
//

import Foundation

// Get auth code from your backend to create Sentiance SDK user
// See https://github.com/sentiance/sample-apps-api
class AuthCodeAPI {
    private static let BACKEND_BASE_URL = "http://localhost:8000/"
    private static let AUTH_END_POINT = "auth/code"
    private static let AUTH_URL = URL(string: BACKEND_BASE_URL + AUTH_END_POINT)!
    
    static func getAuthCodeFromServer(completion: @escaping((_ authCode: String?, _ errorMessage: String?) -> Void)) {
        let request = getAuthCodeRequest()
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            if let authCode = getAuthCodeFromJson(data: data) {
                DispatchQueue.main.async {
                    completion(authCode, nil)
                }
            }
            else {
                let resp = data != nil ? String(decoding: data!, as: UTF8.self) : ""
                DispatchQueue.main.async {
                    completion(nil, "Failed to get authcode, API response: \(resp)) error: \(String(describing: error?.localizedDescription))")
                }
            }
        })
        
        task.resume()
    }
    
    private static func getAuthCodeFromJson(data: Data?) -> String? {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                let authCode = json?["auth_code"] as? String
                return authCode
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    private static func getAuthCodeRequest() -> URLRequest {
        var request = URLRequest(url: AUTH_URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
