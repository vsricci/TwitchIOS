//
//  Box.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import RealmSwift
class Box: Object, Decodable {
    
    
    @objc dynamic var large: String = ""
    
    convenience init(large: String) {
        self.init()
        self.large = large
        
    }
    
    
    enum CodingKeys : String, CodingKey {
        case large
    }
    
    convenience required init(from decoder: Decoder) throws {
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let large = try container.decode(String.self, forKey: .large)
        self.init(large: large)
        
    }
}
