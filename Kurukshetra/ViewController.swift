//
//  ViewController.swift
//  Kurukshetra
//
//  Created by Palash Roy on 12/6/18.
//  Copyright © 2018 Palash Roy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var schedules: Welcome = []
    
    enum rowHeadingColor: String, CaseIterable   {
        case green = "#6CA81D"
        case blue = "#C84C92"
        case pink = "#334FCD"
        case turqoise = "#187CAA"
        case red = "#C96767"
    }
    
    var nameDict = [String: [String]]()
//    var nameDict = ["Amigos": ["Cricket", "DumbCharades", "VollyBall Men", "Carrom"],
//                   "Avengers": ["Badminton men", "Tennis", "Throwball Women", "Dodgeball"],
//                   "Jaguars": ["Singing", "Chess", "Dancing", "Badminton Women"],
//                   "Rudras": ["Tugofwar Men", "Tugofwar women", "Sudoku", "Badminton Mixed Doubles"],
//                   "Warhawks": ["BasketBall", "TableTennis Men", "TableTennis Women", "Cricket Women"]]
    
    @IBOutlet weak var amigosCollectionView: UICollectionView!
    
    //@IBOutlet weak var avengerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "Kurukshetra"
        amigosCollectionView.delegate = self
        amigosCollectionView.dataSource = self
        let urlString = "https://jsonblob.com/api/jsonBlob/91006de3-06c1-11e9-bcad-7bdacdc922d0"
        
        let url = URL.init(string: urlString)
        
        let task = URLSession.shared.welcomeTask(with: url!) { schedule, response, error in
             if let schedule = schedule {
                self.schedules = schedule
//                let vc: TabViewController = self.navigationController?.tabBarController as! TabViewController
//                vc.allGames = schedule
                self.processData()
                DispatchQueue.main.async {
                    self.amigosCollectionView.reloadData()
                }
                
             }
           }
           task.resume()
}
    
    func processData() {
        let inputArray = Set(schedules.map({(s: WelcomeElement) -> ([String: String]) in  [s.ownerName: s.gameName]}))
//        nameDict.removeAll()
        var arr: [String] = [String]()
        for item in inputArray {
            if let val = item.first?.value, let key =  item.first?.key {
                arr = nameDict[key] ?? [String]()
                arr.append(val)
                nameDict[key] = arr
            }
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1
        
        return nameDict.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let keyArr = [String] (nameDict.keys.sorted())
        let eventArr = nameDict[keyArr[section]]
        return eventArr?.count ?? 4
    }
        

    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let keyArr = [String] (nameDict.keys.sorted())
        var reusableView : UICollectionReusableView? = nil
        
        // Create header
        if (kind == UICollectionView.elementKindSectionHeader) {
            // Create Header
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "collectionHeader", for: indexPath)
            let label: UILabel = headerView.viewWithTag(13) as! UILabel
            label.text = keyArr[indexPath.section]
            let color = UIColor(hexString: rowHeadingColor.allCases[indexPath.section].rawValue)
            let image: UIImageView = headerView.viewWithTag(14) as! UIImageView
            image.backgroundColor = color
            reusableView = headerView
            
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width)/2 - 2.0
        let height: CGFloat = (collectionView.frame.width)/2 - 2.0
        var cellSize: CGSize
        
        cellSize = CGSize(width: width, height: height)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "scheduleVC") as? ScheduleViewController
            vc?.schedules = schedules
            let keyArr = [String] (nameDict.keys.sorted())
            let eventArr = nameDict[keyArr[indexPath.section]]
            let event: String = eventArr?[indexPath.row] ?? "Tennis"
            vc?.event = event
            self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let keyArr = [String] (nameDict.keys.sorted())
        
        let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
        
                if let image = cell.eventImageView, let label = cell.eventNameLabel {
                let eventArr = nameDict[keyArr[indexPath.section]]
                let tempimgName: String = eventArr?[indexPath.row] ?? "Tennis"
                var imgName = ""
                if let imageName = tempimgName.components(separatedBy: " ").first {
                    imgName = "\(imageName).png"
                } else {
                    imgName = "Tennis.png"
                }
//                    image.layer.borderWidth = 1
//                    image.layer.borderColor = UIColor.blue.cgColor
                label.text = eventArr?[indexPath.row]
                image.image = UIImage(named:imgName )
                //image.contentMode = .scaleAspectFit
        }
            
        
            return cell
        
        
    }
}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

