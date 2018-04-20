//
//  APITwitchmanager.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import Alamofire

class APITwitchManager {
    
    static let manager = Alamofire.SessionManager.default
    
    static func getTopGames(url: String, limit: Int, successResponse: @escaping (Any?, Int?) -> Void){
        let headers : HTTPHeaders = ["Client-ID": clientID]
        
        let urlRequest = url+"&limit=\(limit)"
        manager.request(urlRequest, method: .get, headers: headers).validate().responseJSON { (response) in
            
            let statusCode = response.response?.statusCode
            switch response.result {
                
            case .success:
                guard let responseJSON = response.result.value as? [ String: Any] else {
                    successResponse(nil, statusCode)
                    return
                }
                
                
                let jsonData = try? JSONSerialization.data(withJSONObject: responseJSON, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData!, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let decode = try! JSONDecoder().decode(Twitch.self, from: data!)
                successResponse(decode, nil)

            case .failure(let error):
                successResponse(error.localizedDescription, statusCode)
            }
        }
        
    }
}
