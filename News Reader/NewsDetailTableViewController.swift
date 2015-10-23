//
//  NewsDetailViewController.swift
//  News Reader
//
//  Created by Alexey on 08.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NewsDetailTableViewController: UITableViewController {
    var item: Item?
    
    let detailNewsCellIdentifier = "DetailNewsCell"
    let categoriesNewsCellIdentifier = "CategoriesNewsCell"
    let mediaNewsCellIdentifier = "MediaNewsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let _ = self.item else {
            return 1
        }
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Categories"
        } else if section == 2 {
            return "Media"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let item = self.item {
            if section == 0 {
                return 1
            } else if section == 1 {
                return item.categories.count
            } else if section == 2 {
                return item.media.count
            }
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let item = self.item else {
            return UITableViewCell()
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.categoriesNewsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel?.text = Array(item.categories.keys)[indexPath.row]
            
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.categoriesNewsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel?.text = item.media[indexPath.row].absoluteString
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.detailNewsCellIdentifier) as! DetailNewsCell
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.date
        cell.authorLabel.text = item.creator
        cell.descriptionLabel.text = item.minifiedDescription
        if let image = item.thumbnailImage {
            cell.thumbnailImageView.image = image
        } else if let imageURL = item.thumbnail {
            cell.thumbnailImageView.setImageFromURL(imageURL)
        } else {
            cell.thumbnailImageView.frame = CGRectNull
        }
        
        return cell
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
