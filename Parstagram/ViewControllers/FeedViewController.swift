//
//  FeedViewController.swift
//  Parstagram
//
//  Created by csuser on 2/26/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let refreshControl = UIRefreshControl()
    var numOfPosts: Int!
  

    @IBOutlet weak var postsTableView: UITableView!
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        postsTableView.refreshControl = refreshControl

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        
    }
    
    @objc func onRefresh() {
        loadPosts()
    }
    

    
    @objc func loadPosts() {
        numOfPosts = 20
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = numOfPosts
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.postsTableView.reloadData()
            }
        }
        
        refreshControl.endRefreshing()
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.authorLabel.text = user.username
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
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
