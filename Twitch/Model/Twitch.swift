//
//  Twitch.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import RealmSwift


class Twitch : Object, Decodable {
    
     var top = List<Top>()
    
    convenience init(top: List<Top>) {
        self.init()
        self.top = top
    }
    
    
    enum CodingKeys : String, CodingKey {
        
        case top
        
        
    }
    
    convenience required init(from decoder: Decoder) throws {
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let resultsArray = try container.decode([Top].self, forKey: .top)
        let tops = List<Top>()
        tops.append(objectsIn: resultsArray)
        self.init(top: tops)
        
    }
    
}
