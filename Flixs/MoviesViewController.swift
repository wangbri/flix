//
//  MoviesViewController.swift
//  Flixs
//
//  Created by Brian Wang on 1/25/16.
//  Copyright © 2016 wangco. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {//UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var networkErrorLabel: UILabel!

    @IBOutlet weak var searchBar: UISearchBar!
    
    //@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var movies: [NSDictionary]?
    
    var movieTitles = [String]()
    
    var moviePosters = [String]()
    
    var data: [String: String] = [:]
    
    var filteredData: [String: String] = [:]
    
    var filteredTitles = [String](count: 20, repeatedValue: "empty")
    
    var filteredPosters = [String](count: 20, repeatedValue: "empty")
    
    var startLocation: CGPoint? //does not work yet
    
    var searchActive : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        loadDataFromNetwork()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)

        
        
        //task.resume()
        //self.networkErrorLabel.hidden = true
        self.networkErrorLabel.alpha = 0
        var networkErrorLabelFrame = self.networkErrorLabel.frame
        networkErrorLabelFrame.origin.y = -69
        self.networkErrorLabel.frame = networkErrorLabelFrame

        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(networkErrorLabel);
        self.view.bringSubviewToFront(searchBar);
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
       //not working atm
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panedView:"))
        self.view.addGestureRecognizer(panRecognizer)
        
        //filteredData = movieTitles
    }
    
    /*func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = movieTitles
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = movieTitles.filter({(dataItem: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if dataItem.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        self.collectionView.reloadData()
    }*/
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredTitles = movieTitles.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        /*filteredPosters = moviePosters.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })*/
        /*if(filteredTitles.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }*/
        if(filteredPosters.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.collectionView.reloadData()
    }

    
    //not working atm
    func panedView(sender: UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            startLocation = sender.locationInView(self.view);
        }
        else if (sender.state == UIGestureRecognizerState.Ended) {
            let stopLocation = sender.locationInView(self.view);
            let dx = stopLocation.x - startLocation!.x;
            //let dy = stopLocation.y - startLocation.y;
            let distance = dx//sqrt(dx*dx + dy*dy );
            print("Distance: \(distance)");
            
            if distance > 400 {
                //do what you want to do
                
            }
            
        }
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    /*@IBAction func onTap(sender: AnyObject) {
        searchBar.resignFirstResponder()
    }*/
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        //self.searchBar.alpha = 0
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 3)
        
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                // ... Use the new data to update the data source ...
                
                // Reload the tableView now that there is new data
                
            
                
                if let _ = error {
                    //self.networkErrorLabel.hidden = false
                    
                    UIView.animateWithDuration(0.5, animations: {
                        var networkErrorLabelFrame = self.networkErrorLabel.frame
                        networkErrorLabelFrame.origin.y = -44
                        self.networkErrorLabel.frame = networkErrorLabelFrame
                        self.networkErrorLabel.alpha = 1
                        
                        /*var searchBarFrame = self.searchBar.frame
                        searchBarFrame.origin.y = 0
                        self.searchBar.frame = searchBarFrame
                        self.searchBar.alpha = 1*/
                    })
                } else {
                    UIView.animateWithDuration(0.5, animations: {
                        var networkErrorLabelFrame = self.networkErrorLabel.frame
                        networkErrorLabelFrame.origin.y = -69
                        self.networkErrorLabel.frame = networkErrorLabelFrame
                        self.networkErrorLabel.alpha = 0
                        
                        /*var searchBarFrame = self.searchBar.frame
                        searchBarFrame.origin.y = 0
                        self.searchBar.frame = searchBarFrame
                        self.searchBar.alpha = 1*/
                    })
                }
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.collectionView.reloadData()
                            
                    }
                }
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
        });
        task.resume()
    }
    
    func loadDataFromNetwork() {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 4.5)
        
        // Configure session so that completion handler is executed on main UI thread
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let _ = error {
                    //self.networkErrorLabel.hidden = false
                   
                    UIView.animateWithDuration(0.5, animations: {
                    var networkErrorLabelFrame = self.networkErrorLabel.frame
                    networkErrorLabelFrame.origin.y = 0
                    self.networkErrorLabel.frame = networkErrorLabelFrame
                    self.networkErrorLabel.alpha = 1
                    })
                }
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.collectionView.reloadData()
                            
                            //var movieTitles = [AnyObject]()
                            
                            //to get data (titles) into array
                            for movie: NSDictionary in (responseDictionary["results"] as! [NSDictionary]){
                                
                                self.movieTitles.append(movie["title"]! as! String)
                                self.moviePosters.append(movie["poster_path"]! as! String)
                            }
                            
                            for (index, element) in self.moviePosters.enumerate()
                            {
                                self.data[element] = self.movieTitles[index]
                            }
                            
                            self.filteredTitles = self.movieTitles
                            self.filteredPosters = self.moviePosters
                            
                            for (index, element) in self.filteredPosters.enumerate()
                            {
                                self.filteredData[element] = self.filteredTitles[index]
                            }
                            
                            print(self.data)
                            
                    }
                }
        })
        
        task.resume()
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
    }*/
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*if let _ = movies {
            //print(filteredData.count)
            //print(movieTitles)
            return filteredData.count
        } else {
            return 0
        }*/
        if(searchActive) {
            return filteredTitles.count
        }
        return movieTitles.count
    }
    
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        if(searchActive){
            cell.titleLabel?.text = filteredTitles[indexPath.row]
            //cell.posterView
        } else {
            cell.titleLabel?.text = movieTitles[indexPath.row];
        }
        
        if(searchActive){
            if let posterPath = filteredPosters[indexPath.row] as? String {
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                let posterUrl = NSURL(string: posterBaseUrl + posterPath)
                cell.posterView.setImageWithURL(posterUrl!)
            }
            else {
                // No poster image. Can either set to nil (no image) or a default movie poster image
                // that you include as an asset
                cell.posterView.image = nil
            }
            //cell.posterView
        } else {
            if let posterPath = moviePosters[indexPath.row] as? String {
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                let posterUrl = NSURL(string: posterBaseUrl + posterPath)
                cell.posterView.setImageWithURL(posterUrl!)
            }
            else {
                // No poster image. Can either set to nil (no image) or a default movie poster image
                // that you include as an asset
                cell.posterView.image = nil
            }
        }
        
        //let movie = movies![indexPath.row]
        
        
        /*if let title = movie["title"] as? String{
            cell.titleLabel.text = title
        }
        else {
            cell.titleLabel.text = nil
        }*/
        //let overview = movie["overview"] as! String
        

        
        /*if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            cell.posterView.setImageWithURL(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterView.image = nil
        }*/
        
        //cell.titleLabel.text = title
        //cell.overviewLabel.text = overview
        
        
        
        //cell.titleLabel?.text = filteredTitles[indexPath.row]
        
        
        
        
        
        print("row \(indexPath.row)")
        return cell
    }
    
    /*func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movieTitles: movieTitles.filter({(dataString: String) -> Bool in
            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
    }*/

    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //NOTES: COMBINE TWO ARRAYS INTO A DICTIONARY TO TIE INDEX ROW VALUES OF TITLES TO POSTERS AND THEN TAKE THE TITLES
    
    
    
    
    
}
