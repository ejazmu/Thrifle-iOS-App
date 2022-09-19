//
//  AdListingViewController.swift
//  Thrifile
//
//  Created by Asad Hussain on 11/07/2022.
//

import UIKit

class AdListingViewController: UIViewController {
    
    var page = 1
    var pageLimit = 1
    
    enum listingType {
        case list
        case grid
    }
    
    var firstLoad : Bool = true
    var listingViewType : listingType = AppConstants.isListView ? .list : .grid
    
    enum viewType {
        case featuredDeals
        case allDeals
        case miltary
        case blogs
    }
    
    var dataSetOfListing : [ListingModel] = [ListingModel](){
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var viewToDisplayTyple : viewType = .featuredDeals
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listingViewType = AppConstants.isListView ? .list : .grid
        self.collectionView.reloadData()
    }
    
    func getDeals() {
        
        if firstLoad {
            showSVLoader()
            firstLoad = false
        }
        
        if viewToDisplayTyple == .featuredDeals {
            UserManager.shared.getFeaturedDeals(page: page) { status1, dataSet , pageLimit in
                
                if dataSet.count == 0 && self.dataSetOfListing.count == 0 {
                    showErrorMessage(message: "No listing available at the moment")
                } else {
                    self.pageLimit = pageLimit
                    if self.page > 0 {
                        self.dataSetOfListing.append(dataSet)
                        self.collectionView.reloadData()
                    } else {
                        self.dataSetOfListing = dataSet
                    }
                }
                
            }
        } else if viewToDisplayTyple == .allDeals {
            UserManager.shared.getAllAds(page: page) { status1, dataSet , pageLimit in
                
                if dataSet.count == 0 && self.dataSetOfListing.count == 0 {
                    showErrorMessage(message: "No listing available at the moment")
                } else {
                    self.pageLimit = pageLimit
                    if self.page > 0 {
                        self.dataSetOfListing.append(dataSet)
                        self.collectionView.reloadData()
                    } else {
                        self.dataSetOfListing = dataSet
                    }
                }
                
            }
        } else if viewToDisplayTyple == .miltary {
            
            UserManager.shared.getMilatrayDeals(page: page) { status1, dataSet, pageLimit in
                if dataSet.count == 0 && self.dataSetOfListing.count == 0 {
                    showErrorMessage(message: "No listing available at the moment")
                } else {
                    self.pageLimit = pageLimit
                    if self.page > 0 {
                        self.dataSetOfListing.append(dataSet)
                        self.collectionView.reloadData()
                    } else {
                        self.dataSetOfListing = dataSet
                    }
                }
            }
            
        } else if viewToDisplayTyple == .blogs {
            
            UserManager.shared.getAllBlogs { status1, dataSet in
                if dataSet.count == 0 {
                    showErrorMessage(message: "No blogs available at the moment")
                } else {
                    self.dataSetOfListing = dataSet
                }
            }
            
        }
        
        
        
    }
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    
    @IBAction func btn_Action_Logout(_ actionLogout : Any){
        
        
        if listingViewType == .grid {
            listingViewType = .list
        } else {
            listingViewType = .grid
        }
        
        collectionView.reloadData()
        
    }
    
    
    
    
    
    @IBAction func btnActionOpenSearch(_ sender : Any) {
        let viewController = StoryboardRef.mainSB.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        self.navigationController?.present(viewController, animated: false, completion: nil)
    }
    
    
    @IBAction func btnActionSideMenu(_ sender : Any) {
        let viewController = StoryboardRef.mainSB.instantiateViewController(identifier: "SideMenuViewController") as! SideMenuViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AdListingViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSetOfListing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewToDisplayTyple != .blogs {
            if listingViewType == .list {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListingCollectionViewCell", for: indexPath) as! ListingGridCollectionViewCell
                let data = dataSetOfListing[indexPath.row]
                cell.updateDataOfCell(listingModel: data)
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListingGridCollectionViewCell", for: indexPath) as! ListingGridCollectionViewCell
                let data = dataSetOfListing[indexPath.row]
                cell.updateDataOfCell(listingModel: data)
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogsGridCollectionViewCell", for: indexPath) as! ListingGridCollectionViewCell
            let data = dataSetOfListing[indexPath.row]
            cell.updateDataForBlogCell(listingModel: data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == dataSetOfListing.count - 5 { // last cell
            if pageLimit > page {
                page += 1
                getDeals() // increment `fromIndex` by 20 before server call
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewToDisplayTyple == .blogs {
            let viewController = StoryboardRef.mainSB.instantiateViewController(identifier: "WebViewController") as! WebViewController
            viewController.url = "https://www.thrifle.com/blog/\(dataSetOfListing[indexPath.row].title.filter {!$0.isWhitespace})/\(dataSetOfListing[indexPath.row].id ?? "")"
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = StoryboardRef.mainSB.instantiateViewController(identifier: "AdDetailViewController") as! AdDetailViewController
            viewController.listingModel = dataSetOfListing[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewToDisplayTyple != .blogs {
            if listingViewType == .list {
                let lay = collectionViewLayout as! UICollectionViewFlowLayout
                let widthPerItem = collectionView.frame.width - lay.minimumInteritemSpacing
                return CGSize(width:widthPerItem, height:120)
            } else {
                let lay = collectionViewLayout as! UICollectionViewFlowLayout
                let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
                return CGSize(width:widthPerItem, height:230)
            }
        } else {
            let lay = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
            return CGSize(width:widthPerItem, height:230)
        }
    }
    
    
    class func viewController() -> AdListingViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainSB") as! AdListingViewController
    }
    
    
    
}


extension AdListingViewController : didAddTextForSearch {
    
    func textForSearchAdded(text: String) {
        self.tabBarController?.selectedIndex = 0
        UserManager.shared.getSearchResults(text: text) { status1, dataSet in
            if dataSet.count == 0 {
                showErrorMessage(message: "No listing available at the moment")
            } else {
                self.dataSetOfListing = dataSet
            }
        }
    }
    
    
}
