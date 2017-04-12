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


class RemoteAPI {
    func getData(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        let url: NSURL = NSURL(string: "https://itunes.apple.com/search?term=google&media=software")!
        let ses = NSURLSession.sharedSession()
        let task = ses.dataTaskWithURL(url, completionHandler: {(data, response, error) in
            if let data = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary

//                    print (json["results"])
                    return completionHandler(json["results"] as! [NSDictionary], nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else {
                print ("error...")
            }
            
        })
        task.resume()
    }
}



var api = RemoteAPI()


class ReelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHPagingMenuDelegate {
    var tableView: UITableView!
    var items: NSMutableArray = []
    var imageList: NSMutableArray = []
    var left = true
    
    func ImageAPI () {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        if let url = NSURL(string: "https://placeholdit.imgix.net/~text?txtsize=33&txt=350%C3%97150&w=350&h=150g"){
            
            let task = session.dataTaskWithURL(url, completionHandler: {data, response, error in
                
                if let err = error {
                    print("Error: \(err)")
                    return
                }
                
                if let http = response as? NSHTTPURLResponse {
                    if http.statusCode == 200 {
                        let downloadedImage = UIImage(data: data!)
                        dispatch_async(dispatch_get_main_queue(), {
//                            self.testImageView.image = downloadedImage
                        })
                    }
                }
            })
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.pagingMenuViewController().delegate = self
        
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        ref.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) -> Void in
            self.co.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: self.kSectionComments)], with: UITableViewRowAnimation.automatic)
        })
        
        
        
        
        
        startTimer()
        
        self.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.tableView = UITableView(frame:self.view!.frame)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view?.addSubview(self.tableView)
        
        api.getData({data, error -> Void in
            if (data != nil) {
                self.items = NSMutableArray(array: data)
                print ("check this")
//                print(self.items)
                self.tableView!.reloadData()
//                self.view
            } else {
                print("api.getData failed")
                print(error)
            }
        })
        
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
        return self.items.count;
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
        
            if let urlString = self.items[indexPath.row]["artworkUrl512"] as? NSString {
                if let url = NSURL(string: urlString as String) {
                    if let data = NSData(contentsOfURL: url) {
                        cell.imageCellView.image = UIImage(data: data)
                        print ("setting image")
                    }
                }
            }
            

        
        
        
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
        dispatch_source_set_timer(timer!, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 1 * NSEC_PER_SEC) // every 3 seconds for now..., with leeway of 1 second
        dispatch_source_set_event_handler(timer!) { [weak self] in
            
            if let table = self!.tableView {
                if let user = defaults.stringForKey("loggedInUser"){
                    if user != "" {
                        print ("timer test...force pulling new table data because logged in")
//                        table.reloadData()
                    } else {
                        print ("timer test...no data to pull, logged out")

                        self!.items = []
                        self!.imageList = []
//                        table.reloadData()
                    }
                } else {
                    print ("unwrap error")
                }
                
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
