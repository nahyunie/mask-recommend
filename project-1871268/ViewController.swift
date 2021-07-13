//
//  ViewController.swift
//  project-1871268
//
//  Created by mac022 on 2021/05/21.
//

import UIKit

struct items{
    let items : [Item]
}

struct Item{
    var createDt : String
    var deathCnt : String
    var defCnt : String
    var gubun : String
    var incDec : String
    var isolClearCnt : String
    var isolIngCnt : String
    var localOccCnt : String
    var overFlowCnt : String
    var qurRate : String
    var seq : String
    var stdDay : String
    var updateDt : String!
}

enum key : String {
    case createDt = "createDt"
    case deathCnt = "deathCnt"
    case defCnt = "defCnt"
    case gubun = "gubun"
    case incDec = "incDec"
    case isolClearCnt = "isolClearCnt"
    case isolIngCnt = "isolIngCnt"
    case localOccCnt = "localOccCnt"
    case overFlowCnt = "overFlowCnt"
    case qurRate = "qurRate"
    case seq = "seq"
    case stdDay = "stdDay"
    case updateDt = "updateDt"
}

class ViewController: UIViewController {

    let baseURLStringForCovid = "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19SidoInfStateJson?"
    let baseURLStringForMicroDust = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMinuDustFrcstDspth?"
    let apiKey = "sfC%2B3T0gZ7FdnTY5FT5qvVY7wRDui24TnAXPHqwNZjoh5qbeVDv3UXNbTVE6hi6jPD%2Fse0Z4IeenGQRuCAgF5Q%3D%3D"
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
    
    var dustImageUrls : [String] = []
    var dustInfos : [String : String] = [:]
    
    var items : [Item] = []
    var xmlDic : [String: String]?
    var crtElementType : key?
    
    var date = DateFormatter()
    var dateStrForCovid : String?
    var dateStrForMicrodust : String?

    @IBOutlet weak var cityPickerView: UIPickerView!
    override func viewDidLoad() {
        date.dateFormat = "yyyy-MM-dd"
        dateStrForMicrodust = date.string(from: Date())
        date.dateFormat = "yyyyMMdd"
        dateStrForCovid = date.string(from: Date())
        
        super.viewDidLoad()
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        getCovidInfo(date : dateStrForCovid)
        getMicrodustInfo(date : dateStrForMicrodust)

        
    }
}


extension ViewController{
    func getCovidInfo(date : String!){

        
        //  여기 수정
        let urlStr = baseURLStringForCovid+"serviceKey="+apiKey+"&"+"pageNo=1&numOfRows=10&startCreateDt="+date+"&"+"endCreateDt="+date
        
        let url = URL(string: urlStr)!

        var parser = XMLParser(contentsOf: url)
        parser!.delegate = self
        if parser?.parse()==false{
            print("parse fail!")
        }
    }
}

extension ViewController : XMLParserDelegate{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item"{
            xmlDic = [:]
        } else if elementName == "createDt"{
            crtElementType = .createDt
        } else if elementName == "deathCnt"{
            crtElementType = .deathCnt
        } else if elementName == "defCnt"{
            crtElementType = .defCnt
        } else if elementName == "gubun"{
            crtElementType = .gubun
        } else if elementName == "incDec"{
            crtElementType = .incDec
        } else if elementName == "isolClearCnt"{
            crtElementType = .isolClearCnt
        } else if elementName == "isolIngCnt"{
            crtElementType = .isolIngCnt
        } else if elementName == "localOccCnt"{
            crtElementType = .localOccCnt
        } else if elementName == "overFlowCnt"{
            crtElementType = .overFlowCnt
        } else if elementName == "qurRate"{
            crtElementType = .qurRate
        } else if elementName == "seq"{
            crtElementType = .seq
        } else if elementName == "stdDay"{
            crtElementType = .stdDay
        } else if elementName == "updateDt"{
            crtElementType = .updateDt
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard xmlDic != nil, let crtElementType = self.crtElementType else {
            return
        }
        xmlDic?.updateValue(string, forKey: crtElementType.rawValue)
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let xmlDic = self.xmlDic else { return }
        if(elementName=="item"){
            var item : Item
            
            guard let createDt = xmlDic[key.createDt.rawValue],
                  let deathCnt = xmlDic[key.deathCnt.rawValue],
                  let defCnt = xmlDic[key.defCnt.rawValue],
                  let gubun = xmlDic[key.gubun.rawValue],
                  let incDec = xmlDic[key.incDec.rawValue],
                  let isolClearCnt = xmlDic[key.isolClearCnt.rawValue],
                  let isolIngCnt = xmlDic[key.isolIngCnt.rawValue],
                  let localOccCnt = xmlDic[key.localOccCnt.rawValue],
                  let overFlowCnt = xmlDic[key.overFlowCnt.rawValue],
                  let qurRate = xmlDic[key.qurRate.rawValue],
                  let seq = xmlDic[key.seq.rawValue],
                  let stdDay = xmlDic[key.stdDay.rawValue],
                  let updateDt = xmlDic[key.updateDt.rawValue] else {return}
                  
            item = Item(createDt: createDt, deathCnt: deathCnt, defCnt: defCnt, gubun: gubun, incDec: incDec, isolClearCnt: isolClearCnt, isolIngCnt: isolIngCnt, localOccCnt: localOccCnt, overFlowCnt: overFlowCnt, qurRate: qurRate, seq: seq, stdDay: stdDay)
           
            item.createDt = createDt
            item.deathCnt = deathCnt
            item.defCnt = defCnt
            item.gubun = gubun
            item.incDec = incDec
            item.isolClearCnt = isolClearCnt
            item.localOccCnt = localOccCnt
            item.overFlowCnt = overFlowCnt
            item.qurRate = qurRate
            item.seq = seq
            item.stdDay = stdDay
            item.updateDt = updateDt
            
            items.append(item)
            self.xmlDic = nil
        }
        crtElementType = nil
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("error : \(parseError)");
    }
}
extension ViewController{
    func getMicrodustInfo(date : String!){

        
        let urlStr = baseURLStringForMicroDust+"serviceKey="+apiKey+"&returnType=json&numOfRows=100&pageNo=1&"+"searchDate="+date+"&InformCode=PM10"
        
        print(urlStr)
        
        let url = URL(string: urlStr)!
        
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
                DispatchQueue(label: "JsonSync").sync {
                    self.extractMicrodustData(jsonData: jsonData)
                }
            }
        }
        dataTask.resume()
    }
}

extension ViewController{
    func extractMicrodustData(jsonData: Data){
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
            
        if let response = json["response"] as? [String:Any]{
            if let body = response["body"] as? [String:Any]{
                if let items = body["items"] as? [Any]{
                    if items.count == 0 {
                        return
                    }
                    if let apiItem = items[0] as? [String:Any]{
                        dustImageUrls.append(apiItem["imageUrl1"] as! String)
                        dustImageUrls.append(apiItem["imageUrl2"] as! String)
                        dustImageUrls.append(apiItem["imageUrl3"] as! String)
                        dustImageUrls.append(apiItem["imageUrl4"] as! String)
                        dustImageUrls.append(apiItem["imageUrl5"] as! String)
                        dustImageUrls.append(apiItem["imageUrl6"] as! String)
                        DispatchQueue(label: "splitSync").sync {
                            splitDustInfo(apiItem["informGrade"] as! String)
                        }
                    }
                }
            }
        }
    }
}
extension ViewController{
    func splitDustInfo(_ dustInfo : String){
        var info = dustInfo.split(separator: ",")
        
        for i in info{
            var separateInfo = i.split(separator: ":")
            var key = String(separateInfo[0]).trimmingCharacters(in: .whitespaces)
            var value = String(separateInfo[1]).trimmingCharacters(in: .whitespaces)
            dustInfos[key] = value
        }
    }
}
    
extension ViewController{
    func prevInfo(sender : Any?){
        var date = Date()
        date = date - 86400
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateStrForMicrodust = formatter.string(from: date)
        formatter.dateFormat = "yyyyMMdd"
        dateStrForCovid = formatter.string(from: date)
        print(dateStrForCovid!+" "+dateStrForMicrodust!)
        
        DispatchQueue(label: "SerialQueue").sync {
            getMicrodustInfo(date : dateStrForMicrodust)
        }
        DispatchQueue(label: "SerialQueue").sync {
            getCovidInfo(date : dateStrForCovid)
        }
        sleep(1)
        performSegue(withIdentifier: "ShowDetail", sender: sender)

    }
}

extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let alertController = UIAlertController(title: "업데이트 오류", message: "당일의 정보가 업데이트 되지 않았습니다.", preferredStyle: .alert)
        let prevAction = UIAlertAction(title: "어제 정보 보기", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            print("어제 정보 보기")
            self.prevInfo(sender: sender)
            return
        })
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(prevAction)
        alertController.addAction(okAction)

        let detailViewController = segue.destination as! DetailViewController
        
        var cityNames = Array(cities.keys)
        cityNames.sort()
        let selectedCity = cityNames[cityPickerView.selectedRow(inComponent: 0)]
        
        var num : Int!
        
        if selectedCity == "영동" || selectedCity == "영서"{
            for i in 0..<items.count{
                if items[i].gubun == "강원"{
                    num = i
                    break
                }
            }
        } else if selectedCity == "경기북부" || selectedCity == "경기남부"{
            for i in 0..<items.count{
                if items[i].gubun == "경기"{
                    num = i
                    break
                }
            }
        } else{
            for i in 0..<items.count{
                if items[i].gubun == selectedCity{
                    num = i
                    break
                }
            }
        }
        
        
        if items.count == 0 {
            present(alertController, animated: true, completion: nil)
        } else{
            
            detailViewController.covid = items[num].incDec
            detailViewController.region = selectedCity
            detailViewController.microdust = dustInfos[selectedCity]
            detailViewController.imageUrls = dustImageUrls
        }
        print("아이템 갯수 : \(items.count), num = \(num)")

    }
}

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let cityNames = Array(cities.keys)
        return cityNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var cityNames = Array(cities.keys)
        cityNames.sort()
        return cityNames[row]
    }
    
}

