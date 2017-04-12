//
//  ReelViewController.swift
//  Demo
//
//  Created by David Kong on 4/9/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseStorage





//class RemoteAPI {
//    func getData(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
//        let url: NSURL = NSURL(string: "https://itunes.apple.com/search?term=google&media=software")!
//        let ses = NSURLSession.sharedSession()
//        let task = ses.dataTaskWithURL(url, completionHandler: {(data, response, error) in
//            if let data = data {
//                do {
//                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
//
////                    print (json["results"])
//                    return completionHandler(json["results"] as! [NSDictionary], nil)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//            } else {
//                print ("error...")
//            }
//            
//        })
//        task.resume()
//    }
//}
//
//
//
//var api = RemoteAPI()

var paths: [String] = []
class ReelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHPagingMenuDelegate {
    var tableView: UITableView!
    var items: NSMutableArray = []
    var imageList: NSMutableArray = []
    var oldSize = 0
    
    
    
    func updateTable() {
        
        
        
        
        paths = []
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        print ("jauntid:")
        let jauntid = defaults.stringForKey("jauntid")!
        print (jauntid)
        if jauntid != "" {
            self.tableView.hidden = false
            print ("inside if")
            ref.child("jaunt").child(jauntid).child("photos").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                // Get user value
                print ("observe event updating")
                if let value = snapshot.value as? NSDictionary {
                    print("value:")
                    print(value)
                    let photos = value
                    
                    for (key, val) in photos{
                        if let path = val["thumbnail_path"] as? String {
                            print (path)
                            paths.append(path)
                            
                            //                let reference = FIRStorage.storage().referenceWithPath(val["thumbnail_path"]!)
                        }
                        
                        
                    }
                    print ("reloading data")
                    
                    
                    if (paths.count != self.oldSize) {
                        print ("ACTUALLY RELOADING DATA")
                        self.tableView.reloadData()
                        self.oldSize = paths.count
                        
                    } else {
                        print ("SKIP DATA RELOAD")
                    }
                }
            
            
            
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            print ("no jaunt")
            
            if (self.oldSize != 0) {
                paths = []
                print ("dumping table view, reloading with empty")
                self.tableView.hidden = true
                self.tableView.reloadData()
                self.oldSize = 0
            } else {
                print ("SKIP DATA RELOAD with empty")
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        updateTable()
        
        
//
//        
//        // maybe this updates photos automatically
//        // who knows
        
//        var refLive: FIRDatabaseReference!
//        refLive = FIRDatabase.database().referenceWithPath("/jaunt/" + defaults.stringForKey("jauntid")! + "/photos/")
        //
//        refLive.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) -> Void in
//            print ("detected update on fbase")
//            let value = snapshot.value as? NSDictionary
//            print("value:")
//            print(value!)
//            let photos = value!
//            
//            for (key, val) in photos{
//                if let path = val["thumbnail_path"] as? String {
//                    print (path)
//                    self.paths.append(path)
//                    
//                    //                let reference = FIRStorage.storage().referenceWithPath(val["thumbnail_path"]!)
//                }
//                
//                
//            }
//            print ("reloading data")
//            self.tableView.reloadData()
//        })
        

//
        
        
        
        startTimer()
        
        self.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.tableView = UITableView(frame:self.view!.frame)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view?.addSubview(self.tableView)
        
//        api.getData({data, error -> Void in
//            if (data != nil) {
//                self.items = NSMutableArray(array: data)
//                print ("check this")
////                print(self.items)
//                self.tableView!.reloadData()
////                self.view
//            } else {
//                print("api.getData failed")
//                print(error)
//            }
//        })
        
//        ImageAPI({data, error -> Void in
//            if (data != nil) {
//                self.imageList = NSMutableArray(array: data)
//                self.tableView!.reloadData()
//                //                self.view
//            } else {
//                print("image get failed")
//                print(error)
//            }
//        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print ("reel view will appear")
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return paths.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        let cell: ImageCell = ImageCell()
        
//        if let navn = self.items[indexPath.row]["trackName"] as? NSString {
//            cell.textLabel!.text = navn as String
//        } else {
//            cell.textLabel!.text = "No Name"
//        }
//
//        if let desc = self.items[indexPath.row]["description"] as? NSString {
//            cell.detailTextLabel!.text = desc as String
//        }
//        
//        print (String(self.items[indexPath.row]["artworkUrl60"]))
        
        var index = indexPath.row
        print("index: " + String(index))
        let path = paths[indexPath.row]
    
        let reference = FIRStorage.storage().referenceWithPath(path)
        reference.dataWithMaxSize(1 * 2048 * 2048) { (data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                print ("Setting image")
                cell.imageCellView.image = UIImage(data: data!)
            }
        }
        
        var refLive: FIRDatabaseReference!
        refLive = FIRDatabase.database().referenceWithPath("/jaunt/" + defaults.stringForKey("jauntid")! + "/photos/")
        //
        refLive.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) -> Void in
            print ("detected update on fbase in function")
            let value = snapshot.value as? NSDictionary
            let photo = value!
            print(photo["thumbnail_path"]!)
            

            
        
//            if let urlString = self.items[indexPath.row]["artworkUrl512"] as? NSString {
//                if let url = NSURL(string: urlString as String) {
//                    if let data = NSData(contentsOfURL: url) {
//                        cell.imageCellView.image = UIImage(data: data)
//                        print ("setting image")
//                    }
//                }
//            }
        
        })
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SCREEN_WIDTH
    }
    
    func AHPagingMenuDidChangeMenuPosition(form: NSInteger, to: NSInteger) {
//        self.delegate?.AHPagingMenuDidChangeMenuPosition?(1, to: 2)
        
        print ("hmmmm")
        if (form == 1 && to == 2) {
            print ("test")
        }
    }
    
    
    
    
    
    
    
    var timer: dispatch_source_t?
    
    func startTimer() {
        let queue = dispatch_queue_create("com.domain.app.timer", nil) // again, you can use `dispatch_get_main_queue()` if you want to use the main queue
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(timer!, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 1 * NSEC_PER_SEC) // every 3 seconds for now..., with leeway of 1 second
        dispatch_source_set_event_handler(timer!) { [weak self] in
            
            if delegate.controller?.getCurrentPage() == 2 {
                print ("visible")
                let code = String(defaults.stringForKey("shortcode"))
                if (code != "") {
                    print ("...and updating")
                    self!.updateTable()
                } else {
                    print ("not in a jaunt!")
                }
                
            } else {
                print ("invisible")
            }
            
        }
        dispatch_resume(timer!)
    }
    
    func stopTimer() {
        if let timer = timer {
            dispatch_source_cancel(timer)
            self.timer = nil
        }
    }
    
    deinit {
        self.stopTimer()
    }
}
