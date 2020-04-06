//
//  ViewController.swift
//  App5
//
//  Created by Lorena Garcia-Foncillas on 11/03/2020.
//  Copyright © 2020 Lorena Garcia-Foncillas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Player1: UIButton!
    @IBOutlet weak var Player2: UIButton!
    @IBOutlet weak var Player3: UIButton!
    @IBOutlet weak var Player4: UIButton!
    
    //BOOL VARIABLE TO CHECK IF ARDUINO IS READY TO CONNECT
    var Prepare: Bool = false
    //BOOL VARIABLE TO KEEP INSIDE LOOP OF GET REQUEST
    var GetRequest: Bool = true
    var timer1 = Timer()
    var timer2 = Timer()
    var duration = 0
    //STRING VARIABLE OF URL
    var WebURL: String = "http://192.168.137.184"
    //OPTIONAL STRING VARIABLE TO PARSE HTML GAME VALUE
    var Game: NSString?
    //CHARACTER VALUEs TO PARSE HTML
    let sign1 = CharacterSet (charactersIn: "<")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoopGetRequest(on: GetRequest)
    }
    
    //SYNCHRONOUS FUNCTION: SEND GET REQUEST AND SCAN DATA RECEIVED
    func LoopGetRequest(on: Bool){
        if GetRequest == true {
            timer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in guard let timePassed = self else{return}
                timePassed.duration += 1
            })
            timer1 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                let url = URL (string: self.WebURL)
                guard let requestUrl1 = url else {fatalError()}
                //create URL reques
                var request1 = URLRequest(url: requestUrl1)
                         
                //specify HTTP method
                request1.httpMethod = "GET"
                         
                //send HTTP request
                let task1 = URLSession.shared.dataTask(with: request1) {(data, response, error) in
                    //check if error takes place
                    if let error = error {
                        print ("Error took place: \(error)")
                        return
                    }
                             
                    //read HTTP response status code
                    if let response = response as? HTTPURLResponse {
                        print("Response HTTP status code: \(response.statusCode)")
                    }
                             
                    //Convert HTTP response data into string and scan to find value of game
                    if let data = data, let dataString = String(data: data, encoding: .utf8){
                        print("Response data string: \n \(dataString)")
                                 
                        //scanning value of game
                        let scanner1 = Scanner(string: dataString)
                        scanner1.charactersToBeSkipped = self.sign1
                        scanner1.scanUpToCharacters(from: self.sign1, into: &self.Game)
                        if self.Game == "Game:0" {
                            self.Prepare = true
                            self.GetRequest = false
                        }
                    }
                }
                task1.resume()
                
                if self.duration % 4 == 0{
                    if self.GetRequest == true {
                        let alert = UIAlertController(title: "STATUS", message: "We could not connect to the game", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Let's try again", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
         
        }
    }
    
    //FUNCTION FOR EACH PLAYER TO GET INTO DIFFERENT VIEW IF ARDUINO IS READY AND AFTER PRESSING BUTTON
    @IBAction func Player1(sender: UIButton){
        if Prepare == true {
            performSegue (withIdentifier: "segue1", sender: self)
            Prepare = false
            GetRequest = false
            timer1.invalidate()
        }
    }
    
    @IBAction func Player2(sender: UIButton){
        if Prepare == true {
            performSegue (withIdentifier: "segue2", sender: self)
            Prepare = false
            GetRequest = false
            timer1.invalidate()
        }
    }
    
    @IBAction func Player3(sender: UIButton){
        if Prepare == true {
            performSegue (withIdentifier: "segue3", sender: self)
            Prepare = false
            GetRequest = false
            timer1.invalidate()
        }
    }
    
    @IBAction func Player4(sender: UIButton){
        if Prepare == true {
            performSegue (withIdentifier: "segue4", sender: self)
            Prepare = false
            GetRequest = false
            timer1.invalidate()
        }
    }
}

