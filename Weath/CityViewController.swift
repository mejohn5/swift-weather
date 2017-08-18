//
//  CityViewController.swift
//  Weath
//
//  Created by Marcus Johnson on 8/14/17.
//  Copyright © 2017 weather. All rights reserved.
//

import UIKit

class CityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate{
    var cityMO:CityMO?
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var forcast: Forecast!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (cityMO != nil){
            cityLabel.text = cityMO?.name;
            loadForecastData(isDegrees: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func loadForecastData(isDegrees:Bool){
        NetworkUtil.sharedInstance.getFiveDayForecast(lat: (cityMO?.lat)!, lng: (cityMO?.lng)!,isDegrees: isDegrees) { (json) in
            self.forcast = Forecast.init(json: json)
            DispatchQueue.main.async {
                self.loadForecastUI()
                self.collectionView.reloadData()

            }
            
        }
    }
    func loadForecastUI(){
        if let today = forcast.fiveDayForecast.values.reversed().first{
            tempLabel.text = "Temp: \(  today!.highTemp)"
            humidityLabel.text = "Humidity: \(  today!.highHumidity)"
            rainLabel.text = "Wind: \(  today!.maxWindSpeed)\(  today!.maxWindDirection)"

        }
       
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if (self.forcast != nil) {
            return 5
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! ForecastCell
        if let cast = forcast.fiveDayForecast.values.reversed()[indexPath.row] {
            cell.tempLabel.text = "Temp: \(cast.highTemp)"
            cell.humidityLabel.text = "Humidity: \(cast.highHumidity)"
            let date =  forcast.fiveDayForecast.keys.reversed()[indexPath.row]
            cell.dayLabel.text = date
        }
        return cell
    }
    
    @IBAction func metricChange(_ sender: UISegmentedControl) {
        forcast.fiveDayForecast = [String: Day]()
        switch sender.selectedSegmentIndex {
        case 0:
            loadForecastData(isDegrees: true)
            return
        case 1:
            loadForecastData(isDegrees: false)
            return
        default:
            loadForecastData(isDegrees: true)
        }
    }
    func getDateStringForRow(row:Int) -> String{
        switch row {
        case 0:
            return  Date().getDateStringFromUnix(unix: Int(NSDate().timeIntervalSince1970))

        case 1:
            return  Date().getDateStringFromUnix(unix: Int(NSDate().timeIntervalSince1970)+86400*1)
        case 2:
            return  Date().getDateStringFromUnix(unix: Int(NSDate().timeIntervalSince1970)+86400*2)
        case 3:
            return  Date().getDateStringFromUnix(unix: Int(NSDate().timeIntervalSince1970)+86400*3)
        case 4:
            return  Date().getDateStringFromUnix(unix: Int(NSDate().timeIntervalSince1970)+86400*4)
        default:
            return  Date().getDateStringFromUnix(unix: Int(NSDate().timeIntervalSince1970))
        
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
