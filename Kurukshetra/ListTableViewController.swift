//
//  ListTableViewController.swift
//  Kurukshetra
//
//  Created by Palash Roy on 12/13/18.
//  Copyright © 2018 Palash Roy. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    var schedule = Welcome()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.viewControllers![1].title = "List"
        let navC: UINavigationController = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let vc: ViewController = navC.viewControllers.first as! ViewController
        schedule = vc.schedules.sorted(by: {$0.date < $1.date})
        
        //schedule.sort(by: {$0.gameDate})
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return schedule.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let game = schedule[indexPath.section]
        let gameName = game.gameName.split(separator: " ")
        if let imageName = gameName.first {
            cell.imageView?.image = UIImage(named: "\(imageName).png")
        }
        cell.textLabel?.text = getTeams(game: game)
        cell.detailTextLabel?.numberOfLines = 3
        var text = getDetailsHeader(game: game)
        if game.result != "N/A" {
           text += "\n" + game.result
        }
        cell.detailTextLabel?.text = text
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func getTeams(game: WelcomeElement) -> String {
        var text = ""
        switch game.team.count {
        case 1:
            if let teams = game.team.first?.value, let teamname = teams.first {
                text = text + teamname
            }
        case 2:
            let teams = game.team
            //            var text = String()
            var i = 0
            for team in teams {
                    text += " \(team.key)"
                
                if i == 0 {
                    text += " vs"
                    i += 1
                }
            }
            
        default:
            ""
        }
        
        return text
    }
    
    
    func getDetailsHeader(game: WelcomeElement) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMMM"
        var text: String = game.gameName + " is organized by " + game.ownerName
        
        if game.date != "N/A" {
            let date = dateFormatter.date(from: game.date)
            let calendar = Calendar.current
            let month = dateFormatter2.string(from: date!)
            let day = calendar.component(.day, from: date!)
            text += "on \(day), \(month)"
        }
        return text
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
