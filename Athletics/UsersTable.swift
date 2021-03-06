//
//  UsersTable.swift
//  Athletics
//
//  Created by grobinson on 11/3/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit
import Parse

class UsersTable: UITableViewController {
    
    var users: [User] = []
    
    var plus: UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        
        edgesForExtendedLayout = UIRectEdge()
        
        title = "Users"
        
        plus = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "plusTPD:")
//        navigationItem.setRightBarButtonItem(plus, animated: true)
        
        setData(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = users[indexPath.row]
        
        let vc = UserAccess(nibName: "UserAccess",bundle: nil)
        vc.user = user
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func plusTPD(sender: UIBarButtonItem){
        
        let vc = UserEdit(nibName: "UserEdit",bundle: nil)
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func setData(local: Bool){
        
        let query = User.query()
        if local { query?.fromLocalDatastore() }
        query?.whereKey("objectId", notEqualTo: User.currentUser()!.objectId!)
        query?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                
                if local {
                    
                    self.setData(false)
                    
                } else {
                    
                    User.pinAllInBackground(objects)
                    
                }
                
                self.users = objects as! [User]
                self.users.sortInPlace { $0.name < $1.name }
                self.tableView.reloadData()
                
            }
            
            if let error = error { Alert.error(error) }
            
        }
        
    }
    
}

extension UsersTable: UserEditPTC {
    
    func userSaved(user: User) {
        
        
        
    }
    
}