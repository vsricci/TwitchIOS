//
//  DetailsTopGamesViewController.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit
import Alamofire
import Social
class DetailsTopGamesViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var imageTopGame : UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var channelQuantity: UILabel!
    
    
    //MARK: Variavables
    var topGameItemSelected: Top!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.largeTitleDisplayMode = .never
        imageTopGame.sd_setImage(with: URL(string: (topGameItemSelected.game?.box?.large)!), placeholderImage: UIImage(named: ""), options: .cacheMemoryOnly, completed: nil)
        name.text = topGameItemSelected.game?.name
        channelQuantity.text = "\(topGameItemSelected.viewers)"
        // Do any additional setup after loading the view.
    }


    
    // MARK: - Actions methods share game selected
    
    @IBAction func shareGames(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Share Games!!", message: "share Games with peoples", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Facebook Share's", style: .default, handler: { (alertaction) in
            
             self.share((self.topGameItemSelected.game?.name)!, imageContent: UIImage(named: (self.topGameItemSelected.game?.box?.large)!))
        }))
        alert.addAction(UIAlertAction(title: "Twitter Share's", style: .default, handler: { (alertAction) in
            
            self.share((self.topGameItemSelected.game?.name)!, imageContent: UIImage(named: (self.topGameItemSelected.game?.box?.large)!))
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
     func share(_ shareContent:String, imageContent: UIImage?){
        let activityViewController = UIActivityViewController(activityItems: [shareContent , imageContent ?? ""], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }

    
    func showAlert() {
        
        let alert = UIAlertController(title: "Error", message: "Error in share game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

}
