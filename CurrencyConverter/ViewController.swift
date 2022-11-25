//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Zeynep Özdemir Açıkgöz on 13.06.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRateClicked(_ sender: Any) {
        //1) Request & Sensession [internetten veri alacağımız url ye gitmek, istek yollamak]
        //2)Response & Data [responsu veya datayı almak]
        //3) Parsing & JSON Serialization [datayı işlemek]
        
        
        //1.
        
        var semaphore = DispatchSemaphore (value: 0)
        let url = "https://api.apilayer.com/fixer/latest?symbols=CAD%2CCHF%2CGBP%2CJPY%2CUSD%2CTRY&base=TRY"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("NX8RaQvBi0Y6RHXy2K8VOBOssLihgTPj", forHTTPHeaderField: "apikey")
       
//Closure
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil{
                
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else{
                //2.
                if  let data = data {
                    do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        //ASYNC
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["rates"] as? [String : Any]{
                                if let cad = rates["CAD"] as? Double{
                                    self.cadLabel.text = "CAD: \(1/(cad))"
                                }
                                if let chf = rates["CHF"] as? Double{
                                    self.chfLabel.text = "CHF: \(1/(chf))"
                                }
                                if let gbp = rates["GBP"] as? Double{
                                    self.gbpLabel.text = "GBP: \(1/(gbp))"
                                }
                                if let jpy = rates["JPY"] as? Double{
                                    self.jpyLabel.text = "JPY: \(1/(jpy))"
                                }
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD: \(1/(usd))"
                                }
                                if let turkish = rates["TRY"] as? Double{
                                    self.tryLabel.text = "TRY: \(1/(turkish))"
                                }
                                
                            }
                            
                        }
                        
                        
                    }catch{
                        print("error")
                    }}
                }
                
            }
            
           /* guard let data = data else {
                
            print(String(describing: error))
              
              
            return
          }
          print(String(data: data, encoding: .utf8)!)
         
        }*/

        semaphore.signal()
        task.resume()
        semaphore.wait()
    
}
}
