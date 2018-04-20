//
//  ViewController.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit
import RealmSwift
class ViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variavibles
    var topGamesArray = List<Top>()
    var topGamesArraySaved : Results<Top>!
    var realm = try! Realm()
    var currentPage = 10
    var isLoading:Bool = false
    var footerView:RefreshCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 5, left: 1, bottom: 5, right: 1)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        collectionView!.collectionViewLayout = layout
    
        connection()
  
    }
    
    
    // MARK - verificy networking
    
    func connection() {
        
        if Reachibility.isInternetAvailable() == true {
            self.getTopGames(url: Urls.urlTopGames.rawValue, limit: currentPage)
            getTopGamesSaved()
        }
        else {
            
            showAlert()
            getTopGamesSaved()
            print(self.topGamesArraySaved.count)
            for item in self.topGamesArraySaved {
                
                print(item.game?.name)
            }
        }
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Not Networking", message: "No Access a Networking", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: { (alertaction) in
            
            self.connection()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Connect Api for top Games
    
    func getTopGames(url: String, limit: Int) {
        
        APITwitchManager.getTopGames(url: url, limit: limit) { (result, statusCode) in
            if let gameResponse = result as? Twitch {

                self.topGamesArray = gameResponse.top
            
                DispatchQueue.main.async {
                    
                    do {
                        try!
                            self.realm.write {
                                self.realm.delete(self.topGamesArraySaved)
                                self.realm.add(gameResponse.top)
                                
                        }
                    }
                }
               
                DispatchQueue.main.async {

                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Games Saved in device
    
    func getTopGamesSaved(){
        
        do {
            try!
                self.realm.write {
                   self.topGamesArraySaved = self.realm.objects(Top.self)
                    
            }
        }
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.detailsTopGamesIdentifier.rawValue {
            let topGameSeleted = segue.destination as! DetailsTopGamesViewController
            let indexPath = self.collectionView.indexPathsForSelectedItems![0]
            let itemsTopGame = self.topGamesArraySaved[indexPath.row]
            topGameSeleted.topGameItemSelected = itemsTopGame
        }
    }

    
    // MARK: - ScrollView methods to refresh collectionView 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(fabs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
        print("pullRation:\(pullRatio)")
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = fabs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight >= 0.0
        {
            if (self.footerView?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                    self.currentPage+=10
                    self.getTopGames(url: Urls.urlTopGames.rawValue, limit: self.currentPage)
                    self.isLoading = false
                })
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.topGamesArray.count > 0 {
            return self.topGamesArray.count
        }else {
            return self.topGamesArraySaved.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdentifiersCell.topGamesCell.rawValue, for: indexPath) as! TopGamesCollectionViewCell
        
        if self.topGamesArray.count > 0 {
            
            let items = topGamesArray[indexPath.row]
            cell.customCell(game: items.game!)
            return cell
        }
        else {
            let items = topGamesArraySaved[indexPath.row]
            cell.customCell(game: items.game!)
            return cell
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        return CGSize(width: width*0.49, height: height*0.4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "refreshCell", for: indexPath) as! RefreshCell
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "refreshCell", for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
}

