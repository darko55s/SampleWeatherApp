//
//  WeatherDetailsViewController.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/23/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit

class WeatherDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [WeatherDetailsCellType]()
    var weather: WeatherDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableData()
        registerCells()
        // Do any additional setup after loading the view.
    }
    
    private func setupTableData() {
        tableData = [.title, .windSpeed, .windDirection, .humidity, .preasure, .predictability, .visibility]
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "titleCell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .white
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension WeatherDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableData[indexPath.row]
        if data == .title {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as! TitleTableViewCell
            cell.setupCell(weather: weather!)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoTableViewCell
            cell.cellType = data
            cell.setupCell(weather: weather!)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = tableData[indexPath.row]
        if data == .title {
            return 100
        }
        return 44
    }
    
}
