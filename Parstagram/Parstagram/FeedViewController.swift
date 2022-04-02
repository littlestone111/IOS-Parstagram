//
//  FeedViewController.swift
//  Parstagram
//
//  Created by LiYang on 3/25/22.
//

import UIKit
import Parse
import MessageInputBar


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate{
    
    
    

    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var selectedPost: PFObject!
    var refreshControl: UIRefreshControl!
    
    var numberOfposts: Int!
    var showsCommentBar = false
    let commentBar = MessageInputBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    @objc func loadPosts(){
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.includeKey("comments")
        query.includeKey("comments.author")
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
        query.includeKey("comments")
        query.includeKey("comments.author")
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
        
        let post = posts[section]
        let comment = (post["comments"] as? [PFObject]) ?? []

        return 2 + comment.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
            let user = post["author"] as! PFUser
            
            cell.authorText.text = user.username
            cell.captionText.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af.setImage(withURL: url)
            
            return cell
        } else if indexPath.row <= comments.count{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]

            cell.comment.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.author.text = user.username
            
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1{
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
        }
        

    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")

        selectedPost.saveInBackground { success, error in
            if success {
                print("Comment Saved")
            }else{
                print("Error saving comment")
            }
        }
        tableView.reloadData()
        
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
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
