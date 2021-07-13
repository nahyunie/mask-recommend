//
//  WeatherViewController.swift
//  project-1871268
//
//  Created by mac022 on 2021/05/23.
//

import UIKit

class WeatherViewController: UIViewController {

    let baseURLStringForWeather="https://api.openweathermap.org/data/2.5/weather"
    let apiKeyForWeather="3d3c4cf82d75b2abbcba6e914358550d"
    
    var cities: [String:[String:Double]]=[
        "제주" : ["lon":126.5219, "lat":33.5097],
        "경남" : ["lon":129.2472, "lat":25.5568],
        "경북" : ["lon":128.1623, "lat":36.4168],
        "전남" : ["lon":127.1049, "lat":36.8202],
        "전북" : ["lon":127.4153, "lat":35.4315],
        "충남" : ["lon":126.8247, "lat":35.1603],
        "충북" : ["lon":127.4784, "lat":36.9959],
        "영동" : ["lon":128.8768, "lat":37.7560],
        "영서" : ["lon":127.9196, "lat":37.3422],
        "경기북부" : ["lon":127.0337, "lat":37.7382],
        "경기남부" : ["lon":127.0286, "lat":37.2644],
        "세종" : ["lon":127.2887, "lat":36.4802],
        "울산" : ["lon":129.3115, "lat":35.5397],
        "대전" : ["lon":128.1019, "lat":35.1940],
        "광주" : ["lon":127.3905, "lat":36.3483],
        "인천" : ["lon":126.9758, "lat":37.4377],
        "대구" : ["lon":127.6487, "lat":35.0052],
        "부산" : ["lon":126.2809, "lat":33.3488],
        "서울" : ["lon":126.9778, "lat":37.5683]
    ]
    
    var cityName : String!
    var tempStr : String!
    var temp : Double!
    var clothesText: String!
    
    @IBOutlet weak var clothesImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var clothesLabel: UILabel!
    
    var clothesImage : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherInfo()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tempLabel.text = tempStr
        self.regionLabel.text = "현재 "+cityName+"의 기온은"
        self.clothesLabel.text = clothesText
        
    }

}
extension WeatherViewController{
    func setClothesImageView(_ temp : Double){
        if temp < 5{
            clothesImage = UIImage(named:"outfit/1.JPG")
            DispatchQueue.main.sync {
                clothesImageView.image = clothesImage
                clothesText = "패딩, 두꺼운 니트, 목도리, 기모제품을 착용하시는건 어떨까요?🧣"
            }
        }
        else if temp>5 && temp<8{
            clothesImage = UIImage(named:"outfit/2.JPG")
            DispatchQueue.main.sync {
                clothesImageView.image = clothesImage
                clothesText = "코트, 가죽자켓, 히트텍, 니트, 레깅스를 입을 날씨입니다!🧥"
            }
        }
        else if temp>8 && temp<11{
            clothesImage = UIImage(named:"outfit/3.JPG")
            DispatchQueue.main.sync {
                clothesImageView.image = clothesImage
                clothesText = "자켓, 트렌치코트, 야상, 니트, 청바지, 스타킹을 입어보세요!👖"
            }
        }
        else if temp>11 && temp<16{
            clothesImage = UIImage(named:"outfit/4.JPG")
            DispatchQueue.main.sync {
                clothesImageView.image = clothesImage
                clothesText = "자켓, 가디건, 야상, 스타킹, 청바지, 면바지 착용을 권장합니다!✨"
            }
        }
        else if temp>16 && temp<19{
            clothesImage = UIImage(named:"outfit/5.JPG")
            DispatchQueue.main.sync {
                clothesImageView.image = clothesImage
                clothesText = "얇은 니트, 맨투맨, 가디건, 청바지를 추천해요!🌈"
            }
        }
        else if temp>19 && temp<22{
            clothesImage = UIImage(named:"outfit/6.JPG")
            DispatchQueue.main.sync {
                clothesImageView.image = clothesImage
                clothesText = "얇은 가디건, 긴팔, 면바지, 청바지 입기 좋은 날씨에요!🌷"
            }
        }
        else if temp>22 && temp<27{
            clothesImage = UIImage(named:"outfit/7.JPG")
            DispatchQueue.main.sync {
                clothesImageView.image = clothesImage
                clothesText = "반팔, 얇은 셔츠, 반바지, 면바지 착용은 어떨까요?🩳"
            }
        }
        else if temp>28{
            clothesImage = UIImage(named:"outfit/8.JPG")
            DispatchQueue.main.sync {
                clothesImageView.image = clothesImage
                clothesText = "민소매, 반팔, 반바지, 원피스를 입을 날씨입니다!👗"
            }
        }
    }
}

extension WeatherViewController{
    func getWeatherInfo(){
        var cityNames = Array(cities.keys)
        var city = cities[cityName]
        var citylat : String = String(format: "%.4f", city!["lat"] as! CVarArg)
        var citylon : String = String(format: "%.4f", city!["lon"] as! CVarArg)
        
        
        let urlStr = baseURLStringForWeather+"?"+"lat=\(citylat)"+"&"+"lon=\(citylon)"+"&"+"appid="+apiKeyForWeather
        
        let url = URL(string: urlStr)!
        
        print(citylat)
        print(url)
        
        let session = URLSession(configuration: .default)
        

        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request){
            (data, response, error) in
            if let error = error{
                
                print(error)
                return
            }
            if let jsonData = data{
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    print(jsonString)
                }
                DispatchQueue.main.sync {
                    let temp = self.extractWeatherData(jsonData: jsonData)!
                    self.temp = Double(String.init(format: "%.2f", temp))
                    
                    self.tempStr = String.init(format: "%.2f℃", temp)
                    
                    
                }
                self.setClothesImageView(self.temp)
            }
        }
        dataTask.resume()
    }
}

extension WeatherViewController{
    func extractWeatherData(jsonData : Data) -> Double? {
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String :  Any]
        
        if let code = json["cod"]{
            if code is String, code as! String == "404"{
                return (nil)
            }
        }
        
        guard var temperature = (json["main"] as! [String: Double])["temp"] else {
            return nil
        }
        temperature = temperature - 273.0
        return temperature
    }
}
