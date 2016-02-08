//
//  DetailViewController.swift
//  Flixs
//
//  Created by Brian Wang on 2/1/16.
//  Copyright © 2016 wangco. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.contentInset = UIEdgeInsetsMake(0, 0, 2.32*self.tabBarController!.tabBar.frame.size.height, 0)
        
        //scrollView.contentSize = CGSizeMake(posterView.frame.size.width,posterView.frame.size.height + overviewLabel.frame.size.height)
        
        
        
        
        print(scrollView.contentSize)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit()
        
        
        let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "https://image.tmdb.org/t/p/w45"
            let largePosterBaseUrl = "https://image.tmdb.org/t/p/original"
            let smallPosterUrl = NSURL(string: posterBaseUrl + posterPath)
            let largePosterUrl = NSURL(string: largePosterBaseUrl + posterPath)
            //let imageRequest = NSURLRequest(URL: posterUrl!)
            let smallImageRequest = NSURLRequest(URL: smallPosterUrl!)
            let largeImageRequest = NSURLRequest(URL: largePosterUrl!)
            posterView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    var cacheImage: UIImage?
                    
                    // imageResponse will be nil if the image is cached
                    if smallImageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.posterView.alpha = 0.0
                        self.posterView.image = smallImage
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.posterView.alpha = 1.0
                            }, completion: { (sucess) -> Void in
                                
                                // The AFNetworking ImageView Category only allows one request to be sent at a time
                                // per ImageView. This code must be in the completion block.
                                self.posterView.setImageWithURLRequest(
                                    largeImageRequest,
                                    placeholderImage: smallImage,
                                    success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                        
                                        self.posterView.image = largeImage;
                                        cacheImage = largeImage
                                        
                                    },
                                    failure: { (request, response, error) -> Void in
                                        // do something for the failure condition of the large image request
                                        // possibly setting the ImageView's image to a default image
                                })
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.posterView.image = cacheImage
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        
        //scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height + infoView.frame.size.height + self.tabBarController!.tabBar.frame.size.height
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        print(contentHeight)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
