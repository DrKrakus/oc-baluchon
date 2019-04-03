//
//  CityListViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 03/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

    // Set the light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // Delegate
    weak var delegate: IsAbleToReceiveData?
    // Array of city
    var citiesArray: [City] = []
    // Outlets
    @IBOutlet weak var cityListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Change the separator and scroll color
        cityListTableView.separatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3004066781)
        cityListTableView.indicatorStyle = .white

        // Change the background color for cells
        let clearView = UIView()
        clearView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        UITableViewCell.appearance().selectedBackgroundView = clearView

        // Get city list
        getCityList()
    }

    // Close button
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    private func getCityList() {
        guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
            return
        }

        guard let data = try? Data(contentsOf: url) else {
            return
        }

        guard let json = try? JSONDecoder().decode(Cities.self, from: data) else {
            return
        }

        for city in json {
            let cityId = city.id
            let cityName = city.name
            let cityCountry = city.country
            let city = City(id: cityId, name: cityName, country: cityCountry)

            self.citiesArray.append(city)
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityListTableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let currentCity = citiesArray[indexPath.row]
        cell.textLabel?.text = currentCity.name + ", " + currentCity.country
        cell.textLabel?.textColor = .white

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cityListTableView.cellForRow(at: indexPath)!
        guard let selectedCity = cell.textLabel?.text else { return }

        // Save devise
        SettingService.city = selectedCity
        // Pass the devise back to the CurrencyVC
        delegate?.pass(selectedCity)

        self.dismiss(animated: true)
    }
}