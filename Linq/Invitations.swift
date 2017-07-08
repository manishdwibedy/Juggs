//
//  Invitations.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class Invitations: UITableViewController {

    
    
    var invitationsArray = [Invitation]()
    var requestArray = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.rowHeight = 400
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 5
        //invitationsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            let requestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestCell
           
            
            return requestCell
            
        }
        
        let invitationCell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath) as! InvitationCell
    
        return invitationCell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            // Drop Pin on map at the address of the move.
            // Send User a notification saying I accepted.
            //Leave some type of indication saying that it was accepted in the cell
            print("Invitation Accepted")
        }
        accept.backgroundColor = .green
        
        let reject = UITableViewRowAction(style: .normal, title: "Decline") { action, index in
            //Send Host a "Sorry, /(name) doesn't want to join your Move" message.
            //Leave some type of indication saying that it was declined in the cell
            print("Invitation Declined")
        }
        reject.backgroundColor = .red
        
        return [reject, accept]
    }
    

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return false
    }
  

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
