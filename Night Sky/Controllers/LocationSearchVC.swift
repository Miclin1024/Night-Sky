//
//  LocationSearchVC.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/7/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSearchVC: UIViewController {

    var placesClient: GMSPlacesClient!
    var token: GMSAutocompleteSessionToken!
    var filter: GMSAutocompleteFilter!
    var resultsTabelView: UITableView!
    var results: [NSAttributedString] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize session token
        token = GMSAutocompleteSessionToken.init()
        
        // Initialize place client
        placesClient = GMSPlacesClient.shared()
        
        // Create a type filter
        filter = GMSAutocompleteFilter()
        filter.type = .city

        // Add blur and vibrancy effect to view
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        blurEffectView.isUserInteractionEnabled = false
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.view.bounds
        vibrancyEffectView.isUserInteractionEnabled = false

         blurEffectView.contentView.addSubview(vibrancyEffectView)
        view.addSubview(blurEffectView)
        
        // Add search bar to view
        let topSearchBar = UISearchBar()
        topSearchBar.frame = CGRect(x: view.frame.width * 0.04, y: 20, width: view.frame.width * 0.92, height: 60)
        topSearchBar.searchBarStyle = .minimal
        topSearchBar.searchTextField.textColor = .white
        topSearchBar.clipsToBounds = true
        topSearchBar.isTranslucent = true
        topSearchBar.tintColor = .white
        topSearchBar.barTintColor = .white
        topSearchBar.delegate = self
        
        
        view.addSubview(topSearchBar)
        
        // Add table view
        resultsTabelView = UITableView()
        resultsTabelView.backgroundColor = .clear
        resultsTabelView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        resultsTabelView.delegate = self
        resultsTabelView.dataSource = self
        view.addSubview(resultsTabelView)
        resultsTabelView.translatesAutoresizingMaskIntoConstraints = false
        resultsTabelView.topAnchor.constraint(equalTo: topSearchBar.bottomAnchor, constant: 20).isActive = true
        resultsTabelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        resultsTabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        resultsTabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension LocationSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        placesClient?.findAutocompletePredictions(fromQuery: searchText, filter: filter, sessionToken: token, callback: { (results, error) in
            if let error = error {
              print("Autocomplete error: \(error)")
              return
            }
            if let results = results {
                var autoCompleteRes: [NSAttributedString] = []
              for result in results {
                autoCompleteRes.append(result.attributedFullText)
              }
                self.results = autoCompleteRes
                self.resultsTabelView.reloadData()
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = searchBar.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
}

extension LocationSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
        let place = results[indexPath.row].string
        Manager.shared.userLocations.append(Location(withName: place, completion: { loc in
            Manager.shared.addUserLocation(name: loc.name)
        }))
        Manager.shared.delegate?.didAddUserLocation()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let regularFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let boldFont = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        let bolded = results[indexPath.row].mutableCopy() as! NSMutableAttributedString
        bolded.enumerateAttribute(NSAttributedString.Key.gmsAutocompleteMatchAttribute, in: NSMakeRange(0, bolded.length), options: []) {
          (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let font = (value == nil) ? regularFont : boldFont
            bolded.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        cell.textLabel?.attributedText = bolded
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 5
        return cell
    }
}
