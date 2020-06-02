//
//  PromocodeService.swift
//  Cities
//
//  Created by Владислав Казмирчук on 01.06.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation
enum PromocodeStatus: String {
case serverError, codeNotExist, success, codeOver, invalidCode
}

class PromocodeService {
    
    func checkCode(code: String, callback: @escaping (PromocodeStatus)->Void) {
        guard let url = URL(string: "https://citiesgame.000webhostapp.com/check_promo.php") else { callback(.serverError); return }
        guard let percentCode = code.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { callback(.invalidCode); return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "code=\(percentCode)".data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            guard let data = data else { callback(.serverError); return }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { callback(.serverError); return }
            guard let statusCode = jsonData["code"] as? Int else { callback(.serverError); return }
            switch statusCode {
            case 1:
                callback(.success)
            case -1:
                callback(.serverError)
            case -2:
                callback(.codeNotExist)
            case -3:
                callback(.codeOver)
            case -4:
                callback(.invalidCode)
            default:
                callback(.serverError)
            }
        }.resume()
    }
}
