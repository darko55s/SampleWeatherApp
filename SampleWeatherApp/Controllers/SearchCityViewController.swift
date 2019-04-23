//
//  SearchCityViewController.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/23/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import IGListKit

class SearchCityViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
   
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var filterString = ""
    var searchToken = "SearchToken"
    var items = [ListDiffable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search City"
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
}

extension SearchCityViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard filterString != "" else { return [searchToken] as [ListDiffable] }
        
        return [searchToken] + items as! [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, obj == searchToken {
            let searchSection = SearchSectionController()
            searchSection.delegate = self
            return searchSection
        } else {
            let citySection = CitySectionController()
            citySection.delegate = self
            return citySection
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension SearchCityViewController: CitySectionDelegate {
    func didSelectCity(city: CityViewModel?) {
        if let city = city {
            city.userPicked = true
            city.saveViewModel(completion: nil)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func didLongPressCity(city: CityViewModel?) {
        
    }
}

extension SearchCityViewController: SearchSectionDelegate {
    func searchSectionController(_ sectionController: SearchSectionController, didChangeText text: String) {
        filterString = text
        NetworkManager.sharedInstance.searchForCity(searchText: text) { [weak self] (objectIds, error) in
            if let _ = error {
                print(error.debugDescription)
                return;
            }
            if let objects = RealmManager.sharedInstance.find(multipleRealmObjects: .city, filter: NSPredicate(format: "name BEGINSWITH[cd] %@", text)) as? [CityRealmObject] {
                self?.items.removeAll()
                objects.forEach({ self?.items.append( CityViewModel(realmObject: $0)) })
                self?.adapter.performUpdates(animated: true, completion: nil)
                return
            }
        }
        
        if let objects = RealmManager.sharedInstance.find(multipleRealmObjects: .city, filter: NSPredicate(format: "name BEGINSWITH[cd] %@", text)) as? [CityRealmObject] {
            items.removeAll()
            objects.forEach({ items.append( CityViewModel(realmObject: $0)) })
        }
        
        adapter.performUpdates(animated: true, completion: nil)
    }
}
