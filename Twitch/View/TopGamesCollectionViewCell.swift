//
//  TopGamesCollectionViewCell.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit
import  SDWebImage
class TopGamesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var popularity: UILabel!
    
    func customCell(game: Game) {
        image.sd_setImage(with: URL(string: (game.box?.large)!), placeholderImage: UIImage(named: ""), options: .cacheMemoryOnly, completed: nil)
        name.text = game.name
        popularity.text = "Ranking: \(game.popularity)"
    }
}
