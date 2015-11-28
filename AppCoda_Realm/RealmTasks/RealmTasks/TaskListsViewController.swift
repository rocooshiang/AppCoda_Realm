//
//  TaskListsViewController.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/13/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lists : Results<TaskList>!
    
    var isEditingMode = false
    
    var currentCreateAction:UIAlertAction!
    @IBOutlet weak var taskListsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        readTasksAndUpdateUI()
    }
    
    func readTasksAndUpdateUI(){
        
        lists = uiRealm.objects(TaskList)
        //設定UITableView目前不是編輯狀態
        self.taskListsTableView.setEditing(false, animated: true)
        self.taskListsTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - User Actions -
    
    @IBAction func didSelectSortCriteria(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            
            // A-Z
            self.lists = self.lists.sorted("name")
        }else{
            // date 目前資料沒有建立這個項目
            self.lists = self.lists.sorted("createdAt", ascending:false)
        }
        self.taskListsTableView.reloadData()
    }
    
    //Edit按鈕
    @IBAction func didClickOnEditButton(sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        self.taskListsTableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func didClickOnAddButton(sender: UIBarButtonItem) {
        
        displayAlertToAddTaskList(nil)
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    func listNameFieldDidChange(textField:UITextField){
        
        // if UIAlertController textField's word quantity bigger than zero
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    func displayAlertToAddTaskList(updatedList:TaskList!){
        
        /***
        Please note that when you perform multiple writes simultaneously, they will block each other and block the thread they working on. So you should consider doing this in separate thread than the UI. Another thing is that, reads are not blocked while you’re performing write transactions. It’s helpful as your app may perform many reads operation while user navigating the app and in same time write transactions may be working in background.
        ***/
        
        var title = "New Tasks List"
        var doneTitle = "Create"
        if updatedList != nil{
            title = "Update Tasks List"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your tasks list.", preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let listName = alertController.textFields?.first?.text
            
            if updatedList != nil{
                // update mode
                uiRealm.write({ () -> Void in
                    updatedList.name = listName!
                    self.readTasksAndUpdateUI()
                })
            }else{
                // add mode
                let newTaskList = TaskList()
                newTaskList.name = listName!
                
                uiRealm.write({ () -> Void in
                    
                    uiRealm.add(newTaskList)
                    self.readTasksAndUpdateUI()
                })
            }
            print(listName)
        }
        
        alertController.addAction(createAction)
        
        //Update or Create 預設為不能點擊（灰色字體）
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: "listNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            
            //if edit mode , set origin name in textField
            if updatedList != nil{
                textField.text = updatedList.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let listsTasks = lists{
            return listsTasks.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell")
        
        let list = lists[indexPath.row]
        
        cell?.textLabel?.text = list.name
        cell?.detailTextLabel?.text = "\(list.tasks.count) Tasks"
        return cell!
    }
    
    //starting from iOS 8.0
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            let listToBeDeleted = self.lists[indexPath.row]
            uiRealm.write({ () -> Void in
                uiRealm.delete(listToBeDeleted)
                self.readTasksAndUpdateUI()
            })
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // Editing will go here
            let listToBeUpdated = self.lists[indexPath.row]
            self.displayAlertToAddTaskList(listToBeUpdated)
            
        }
        return [deleteAction, editAction]
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("openTasks", sender: self.lists[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tasksViewController = segue.destinationViewController as! TasksViewController
        tasksViewController.selectedList = sender as! TaskList
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}