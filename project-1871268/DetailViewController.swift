//
//  DetailViewController.swift
//  project-1871268
//
//  Created by mac022 on 2021/05/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var covid : String?
    var region : String?
    var microdust : String?
    var imageUrls : [String]?
    var imageNum: Int = 0
    var maskImage : UIImage?

    @IBOutlet weak var dustImageView: UIImageView!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var maskLabel: UILabel!
    @IBOutlet weak var microdustLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var covidLabel: UILabel!
    @IBOutlet weak var maskImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "오늘의 마스크"
        
        covidLabel.text = "코로나 발생 현황 : 🔺"+covid!
        regionLabel.text = region
        microdustLabel.text = "미세먼지 농도 : "+microdust!
        let url = URL(string: imageUrls![imageNum])!
        let data = try! Data(contentsOf: url)
        dustImageView.image = UIImage(data: data)
        let mask = maskCalc(microdust: microdust!, covid: covid!)
        maskLabel.text = mask
        maskImageView.image = maskImage
    }
    

    
}

extension DetailViewController{
    @IBAction func prevImageButton(_ sender: UIButton) {
        if imageNum == 0 {return}
        else{
            imageNum -= 1
            let url = URL(string: imageUrls![imageNum])!
            let data = try! Data(contentsOf: url)
            dustImageView.image = UIImage(data: data)
        }
    }
    @IBAction func nextImageButton(_ sender: UIButton) {
        if imageNum == (imageUrls!.count-1){
            return
        } else{
            imageNum += 1
            let url = URL(string: imageUrls![imageNum])!
            let data = try! Data(contentsOf: url)
            dustImageView.image = UIImage(data: data)
        }
    }
}


extension DetailViewController{
    func maskCalc(microdust : String, covid : String) -> String{
        let covidNum = Int(covid)
        var mask : String!
        
        if covidNum! >= 100 || microdust=="매우나쁨"{
            mask = "kf94\n착용 권장"
            maskImage = UIImage(named: "mask/kf94.jpg")
        } else if (covidNum!>=50 && covidNum!<100) || microdust == "나쁨"{
            mask = "kf80\n착용 권장"
            maskImage = UIImage(named: "mask/kf80.jpg")
        } else if covidNum! < 50 && (microdust=="좋음" || microdust=="보통"){
            mask = "덴탈・kfAD\n착용 권장"
            maskImage = UIImage(named: "mask/dental.jpg")
        } else {
            return ""
        }
        return mask
    }
}
extension DetailViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let weatherViewController = segue.destination as! WeatherViewController

        weatherViewController.cityName = region
    }
}
