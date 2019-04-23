//
//  HomeViewController.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import IGListKit

class HomeViewController: UIViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!

    var items = [ListDiffable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddCityButton()
        setupAdapterAndCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateInitialyCollection()
    }
    
    private func setupAdapterAndCollection() {
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    private func setupAddCityButton() {
        let addNew = UIButton()
        addNew.setImage(UIImage(named: "plus"), for: .normal)
        addNew.addTarget(self, action: #selector(onAddNew), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addNew)
    }
    
    @objc private func onAddNew() {
        performSegue(withIdentifier: "searchSegue", sender: nil)
    }
    
    private func populateInitialyCollection() {
        items.removeAll()
        CityViewModel.findMultiple(filter: NSPredicate(format: "userPicked == true")) { [weak self] cities in
            guard let cities = cities as? [CityViewModel] else { return }
            
            self?.items.append(contentsOf: cities)
            self?.adapter.performUpdates(animated: true, completion: nil)
            self?.fetchCities(cities: cities)
        }
    }
    
    private func insertAndReloadDataFor(cityId: String) {
        if let index = self.items.firstIndex(where: { item -> Bool in
            if let city = item as? CityViewModel {
                return city.id == cityId
            }
            return false
        }) {
            let predicate = NSPredicate(format: "id == %@", cityId)
            if let city = RealmManager.sharedInstance.find(singleRealmObject: .city, filter: predicate) as? CityRealmObject {
                let currentCity = items[index] as! CityViewModel
                let newCity = CityViewModel(realmObject: city)
                newCity.isExpanded = currentCity.isExpanded
                items[index] = newCity
            }
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    private func fetchCities(cities: [CityViewModel]) {
        for city in cities {
            NetworkManager.sharedInstance.getWeatherDetailsFor(cityId: city.id, completion: { [weak self] (id, error) in
                if let _ = error {
                    print("Error")
                } else if let id = id {
                    print("GOT ID:" + id)
                    self?.insertAndReloadDataFor(cityId: id)
                }
            })
        }
    }
    
    private func appendOrRemoveDaysFor(city: CityViewModel) {
        if city.isExpanded {
            if let index = items.firstIndex(where: { item -> Bool in
                if let item = item as? CityViewModel {
                    return item.id == city.id
                }
                return false
            }) {
                let predicate = NSPredicate(format: "id == %@", city.id)
                if let weather = RealmManager.sharedInstance.find(singleRealmObject: .weather, filter: predicate) as? WeatherRealmObject {
                    let w = WeatherViewModel(realmObject: weather)
                    var startIndex = index+1
                    for details in w.details {
                        items.insert(details as ListDiffable, at: startIndex)
                        startIndex = startIndex + 1
                    }
                }
            }
        } else {
           removeAllDaysFor(cityId: city.id)
        }
        
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    private func removeAllDaysFor(cityId: String) {
        let predicate = NSPredicate(format: "id == %@", cityId)
        if let weather = RealmManager.sharedInstance.find(singleRealmObject: .weather, filter: predicate) as? WeatherRealmObject {
            let w = WeatherViewModel(realmObject: weather)
            items.removeAll { (item) -> Bool in
                if let item = item as? WeatherDetailsViewModel {
                    return w.details.contains(where: { $0.id == item.id })
                }
                return false
            }
        }
    }
    
    private func openWeatherDeatilsFor(weather: WeatherDetailsViewModel) {
        
    }
    
    private func openActionSheetFor(city: CityViewModel) {
        let actionSheet = UIAlertController(title: "Deleate", message: "Do you want to delete " + city.name, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.delete(city: city)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func delete(city: CityViewModel) {
        if city.isExpanded {
            removeAllDaysFor(cityId: city.id)
        }
        
        items.removeAll { item -> Bool in
            if let item = item as? CityViewModel {
                if item.id == city.id {
                    item.userPicked = false
                    item.saveViewModel(completion: nil)
                    return true
                }
            }
            return false
        }
        
        adapter.performUpdates(animated: true, completion: nil)
    }
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is CityViewModel {
            let cityController = CitySectionController()
            cityController.delegate = self
            return cityController
        } else {
            let dayController = DaySectionController()
            dayController.delegate = self
            return dayController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension HomeViewController: DaySectionDelegate {
    func didSelectDay(weather: WeatherDetailsViewModel?) {
        if let weather = weather {
            openWeatherDeatilsFor(weather: weather)
        }
    }
}

extension HomeViewController: CitySectionDelegate {
    func didSelectCity(city: CityViewModel?) {
        if let city = city {
            appendOrRemoveDaysFor(city: city)
        }
    }
    
    func didLongPressCity(city: CityViewModel?) {
        if let city = city {
            openActionSheetFor(city: city)
        }
    }
}
