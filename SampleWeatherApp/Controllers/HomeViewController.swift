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
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var items = [ListDiffable]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddCityButton()
        setupAdapterAndCollection()
        populateInitialyCollection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupAdapterAndCollection() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
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
        
    }
    
    private func populateInitialyCollection() {
        CityViewModel.findAll { [weak self] cities in
            if let cities = cities as? [CityViewModel] {
                self?.items.append(contentsOf: cities)
            }
            self?.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    private func fetchCities(cities: [CityViewModel]) {
        for city in cities {
            NetworkManager.sharedInstance.getWeatherDetailsFor(cityId: city.id, completion: { (id, error) in
                if let _ = error {
                    print("Error")
                } else if let id = id {
                    print("GOT ID:" + id)
                }
            })
        }
    }
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CitySectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
