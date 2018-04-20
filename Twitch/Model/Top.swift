//
//  Top.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import RealmSwift
class Top: Object, Decodable {
   
    @objc dynamic var viewers: Int = 0
    @objc dynamic var channels: Int = 0
    @objc dynamic var game: Game? 
    
    
    convenience init(viewers: Int, channels: Int, game: Game) {
        self.init()
        self.viewers = viewers
        self.channels = channels
        self.game = game
    }
    
    
    enum CodingKeys : String, CodingKey {
        case viewers
        case channels
        case game
    }
    
    convenience required init(from decoder: Decoder) throws {
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let viewers = try container.decode(Int.self, forKey: .viewers)
        let channels = try container.decode(Int.self, forKey: .channels)
        let game = try container.decode(Game.self, forKey: .game)
        self.init(viewers: viewers, channels: channels, game: game)
        
    }
}
