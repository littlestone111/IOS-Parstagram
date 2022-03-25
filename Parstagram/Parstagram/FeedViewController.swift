//
//  FeedViewController.swift
//  Parstagram
//
//  Created by LiYang on 3/25/22.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    var refreshControl: UIRefreshControl!
    
    var numberOfposts: Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
    }
    
    @objc func loadPosts(){
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        numberOfposts = 20
        query.limit = numberOfposts
        query.addAscendingOrder("updatedAt")
        query.findObjectsInBackground { (posts_q, error) in
            if posts_q != nil{
                self.posts = posts_q!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func loadMorePosts(){
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = numberOfposts + 1
        
        
        query.findObjectsInBackground { (posts_q, error) in
            if posts_q != nil{
                self.posts = posts_q!
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPosts()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let user = post["author"] as! PFUser
        
        cell.authorText.text = user.username
        cell.captionText.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
