//
//  Game.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import RealmSwift
class Game: Object, Decodable {
    
    @objc dynamic var name: String = ""
    @objc dynamic var popularity: Int = 0
    @objc dynamic var _id : Int = 0
    @objc dynamic var box : Box?
    
    
    
    convenience init(name: String, popularity: Int, _id: Int, box: Box) {
        self.init()
        self.name = name
        self.popularity = popularity
        self._id = _id
        self.box = box
    }
    
    
    enum CodingKeys : String, CodingKey {
        case name
        case popularity
        case _id
        case box
    }
    
    convenience required init(from decoder: Decoder) throws {
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let popularity = try container.decode(Int.self, forKey: .popularity)
        let id = try container.decode(Int.self, forKey: ._id)
        let box = try container.decode(Box.self, forKey: .box)
        self.init(name: name, popularity: popularity, _id: id, box: box)
        
    }
}
