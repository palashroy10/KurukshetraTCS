//
//  ScheduleViewController.swift
//  Kurukshetra
//
//  Created by Palash Roy on 12/8/18.
//  Copyright © 2018 Palash Roy. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    var cellColor = true
    var schedules: Welcome? = Welcome()
    var games: Welcome?
    var event: String?
    var days: [Int] = [Int]()
    var dates:[String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        // Do any additional setup after loading the view.
        self.title = event
        games = schedules?.filter({ $0.gameName == event})
        
        for game in games! {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if game.date != "N/A" {
                let date = dateFormatter.date(from: game.date)
                let calendar = Calendar.current
                let day = calendar.component(.day, from: date!)
                days.append(day)
                dates.append(game.date)
            }
        }
        if let game = games?.first {
            var text = getDetailsHeader(game: game)
            text += getDetailsForGame(game: game)
            detailTextView.text = text
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 60
        let height: CGFloat = 60.0
        var cellSize: CGSize
        cellSize = CGSize(width: width, height: height)
        return cellSize
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.gray
        label.text = "\(indexPath.row + 1)"
        cell.addSubview(label)
        
        
        if days.firstIndex(of: (indexPath.row + 1)) != nil {
            label.backgroundColor = .green
        }
        
        // Configure the cell
        // 3
        
        //        cell.backgroundColor = cellColor ? UIColor.red : UIColor.blue
        //        cellColor = !cellColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = days.firstIndex(of: (indexPath.row + 1)) {
        let date = dates[index]
            var txt = ""
        if let allgames = games?.filter({$0.date == date }) {
            txt += getDetailsHeader(game: allgames.first!)
            for game in allgames {
                txt += getDetailsForGame(game: game) + "\n"
            }
            detailTextView.text = txt
            }
        }
    }
    
    func getDetailsHeader(game: WelcomeElement) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMMM"
        let text: String = game.gameName + " is organized by " + game.ownerName
        return text
    }
    
    func getDetailsForGame(game: WelcomeElement) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMMM"
        var text: String = ""
        if game.date != "N/A" {
            let date = dateFormatter.date(from: game.date)
            let calendar = Calendar.current
            let month = dateFormatter2.string(from: date!)
            let day = calendar.component(.day, from: date!)
            text = text + "on \(day), \(month)"
        }
        
        switch game.team.count {
        case 1:
            if let teams = game.team.first?.value, let teamname = teams.first {
                text = text + "between" + teamname
            }
        case 2:
            let teams = game.team
//            var text = String()
            text += " between"
            var i = 0
            for team in teams {
                if team.value.first == "N/A" {
                    text += " \(team.key)"
                } else {
                    let mems = team.value.joined(separator: ",")
                    text += " \(team.key)(\(mems))"
                }
                if i == 0 {
                    text += " and"
                    i += 1
                }
            }
 
        default:
            ""
        }
        return text
    }
}
