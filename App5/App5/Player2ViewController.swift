//
//  Player2ViewController.swift
//  App5
//
//  Created by Lorena Garcia-Foncillas on 11/03/2020.
//  Copyright © 2020 Lorena Garcia-Foncillas. All rights reserved.
//

import UIKit

class Player2ViewController: UIViewController {

    @IBOutlet weak var Left_button: UIButton!
    @IBOutlet weak var Right_button: UIButton!
    @IBOutlet weak var speed_label: UILabel!
    @IBOutlet weak var timer_label: UILabel!
    @IBOutlet weak var GoBack: UIButton!
    @IBOutlet weak var Ready_button: UIButton!
    @IBOutlet weak var WebUrl: UIWebView!
    
    //VARIABLES FOR POST_REQUEST
    var timer4 = Timer()
    var PostRequestBool: Bool = true
    var PostType: Bool = false
    
    //STRING VARIABLES FOR URL
    var WebURL: String = "http://192.168.137.43"
    
    //VARIABLES FOR TIMER FUNCTIONS
    var TimerOn3: Bool = false
    var TimerOn4: Bool = false
    var timer3 = Timer()
    var Duration3 = 0
    
    //VARIABLE SPEED FUNCTION
    var State = 0
    var velocity: Double = 0
    var probability: Double = 0
    var counter: Double = 0
    var currentState = ["Press Ready", "Preparing"]
    
    //VARIABLE FOR LOOP_GET_REQUEST
    var timer1 = Timer()
    var GetRequest: Bool = false
    let sign1 = CharacterSet (charactersIn: "<")
    var Game: NSString?
    var Player2: NSString?
    
    //VARIABLES FOR TIMED FUNC
    var TimerFunc: Bool = true
    var check: Bool = false
    var timer2 = Timer()
    var colors = [UIColor.green, UIColor.red]
    
    //VARIABLES DISPATCH_QUEUE
    var DispatchBool1: Bool = false
    var DispatchBool2: Bool = true
    
    //VARIABLES SECONFLAP FUNCTION
    var lap2: Bool = false
    var clock = Timer()
    var timing = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Speed()
    }
    
    //FUNCTION: CREATE GET REQUEST (in the context of the game it acts as a POST request)
    func PostRequest(on: Bool){
        timer4 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {_ in
           
            if self.PostType == false {
                let url = URL(string:"http://192.168.137.184/get?player2=ready")!
                var requestPost = URLRequest(url:url)
                self.WebUrl.loadRequest(requestPost)
            }
            else if self.PostType == true {
                let url = URL(string:"http://192.168.137.184/get?player2=\(self.velocity)")!
                var requestPost = URLRequest(url:url)
                self.WebUrl.loadRequest(requestPost)
            }
        }
    }
    
    //SYNCHRONOUS FUNCTION: SEND GET REQUEST
    func LoopGetRequest(on: Bool) {
        if GetRequest == true {
            timer1 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {_ in
                let url = URL (string: self.WebURL)
                guard let requestUrl = url else {fatalError()}
                
                var request = URLRequest(url:requestUrl)
                
                request.httpMethod = "GET"
                
                let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                    if let error = error {
                        print("Error took place: \(error)")
                        return
                    }
                    if let response = response as? HTTPURLResponse {
                        print("Response HTTP status code: \(response.statusCode)")
                    }
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("Response data string: \n \(dataString)")
                        
                        let scanner1 = Scanner(string: dataString)
                        scanner1.charactersToBeSkipped = self.sign1
                        scanner1.scanUpToCharacters(from: self.sign1, into: &self.Game)
                        if self.Game == "Game:1" {
                            scanner1.scanUpToCharacters(from: self.sign1, into: &self.Player2)
                            scanner1.scanUpToCharacters(from: self.sign1, into: &self.Player2)
                            if self.Player2 == "db>Player2:0"{
                                print("lap 1")
                                self.PostType = true
                                self.check = true
                                self.RandomColor()
                                self.TimedFunction(on: self.TimerFunc)
                                self.TimerOn3 = true
                                self.Timer3(on: self.TimerOn3)
                            }
                            else if self.Player2 == "db>Player2:1"{
                                print("lap 2")
                                self.lap2 = true
                                self.SecondLap(on: self.lap2)
                                self.TimerFunc = false
                                self.timer2.invalidate()
                                self.check = false
                            }
                            else if self.Player2 == "db>Player2:2"{
                                print("reset")
                                self.Reset(sender: self.GoBack)
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    //SYNCHRONOUS FUNCTION: SET RANDOM_COLOR AND DISPATCH_QUEUE FUNCTIONS
    func TimedFunction (on: Bool){
        if on {
            if check == true {
                timer2 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {_ in
                    if (self.Left_button.backgroundColor != UIColor.red) || (self.Right_button.backgroundColor != UIColor.red) {
                        self.Left_button.backgroundColor = self.colors[1]
                        self.Right_button.backgroundColor = self.colors[1]
                    }
                    self.RandomColor()
                }
            }
        }
        else {
            timer2.invalidate()
        }
    }
    
    //FUNCTION: GENERATE RANDOM NUMBER, CHANGE COLOR OF CORRESPONDING BUTTON
    func RandomColor(){
        DispatchBool1 = true
        DispatchBool2 = true
        dispatchQueue(on: DispatchBool1)
        let number = Int.random(in: 1..<3)
        if number == 1 {
            self.Left_button.backgroundColor = colors[0]
        }
        else {
            self.Right_button.backgroundColor = colors[0]
        }
    }
    
    //SYNCHRONOUS FUNCTION: SET TIMER ON
       func Timer3 (on: Bool){
           if on{
            timer3 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                guard let clock3 = self else {return}
                clock3.Duration3 += 1
                clock3.timer_label.text = String(clock3.Duration3)
            })
           }
           else {
            timer3.invalidate()
        }
       }
    
    //ASYNCHRONOUS FUNCTION: CHECK AFTER 5 SEC FROM START TIME BUTTON'S COLOR
    func dispatchQueue (on: Bool){
        let seconds: Double = 5
        if DispatchBool2 == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                if (self.Left_button.backgroundColor != UIColor.red) || (self.Right_button.backgroundColor != UIColor.red) {
                    self.Left_button.backgroundColor = self.colors[1]
                    self.Right_button.backgroundColor = self.colors[1]
                }
                return
            }
        }
    }
    
    //FUNCTION: DISPLAY AND CALCULATE SPEED
    func Speed() {
        if TimerOn3 == true {
            if Duration3 < 3 {
                self.speed_label.text = " "
            }
            else {
                probability = (Double(Duration3 / 3))
                velocity = (counter/probability)
                velocity = round(10*velocity)
                if velocity < 40 {
                    self.speed_label.text = "🔴"
                }
                else if (40 < velocity) && (velocity < 60) {
                    self.speed_label.text = "🔴🔴"
                }
                else {
                    self.speed_label.text = "🔴🔴🔴"
                }
            }
        }
        else {
            if State == 0 {
                self.speed_label.text = currentState[0]
            }
            else if State == 1 {
                self.speed_label.text = currentState[1]
            }
        }
    }
    
    //FUNCTION: IF IN 1º ROUND AND IF GREEN COUNTER +=1, IF IN 2º COUNTER =+ 1
    @IBAction func LeftClick(sender: UIButton){
        if Left_button.backgroundColor == UIColor.green {
            counter+=1
            DispatchBool1 = false
            DispatchBool2 = false
        }
    }
    
     //FUNCTION: IF IN 1º ROUND AND IF GREEN COUNTER +=1, IF IN 2º COUNTER =+ 1
    @IBAction func RightClick (sender: UIButton){
        counter+=1
        DispatchBool1 = false
        DispatchBool2 = false
    }
    
    //FUNCTION: SEND POST REQUEST WITH PLAYER#=READY
    @IBAction func Ready(sender: UIButton){
        State = 1
        GetRequest = true
        PostRequest(on: PostRequestBool)
        LoopGetRequest(on: GetRequest)
    }
    
    //FUNCTION: RESET ALL VARIABLES, GO BACK TO MAIN MENU
    @IBAction func GoBack(sender: UIButton){
        Reset(sender: GoBack)
    }
    
    // FUNC: CHANGE COLOR OF BOTH BUTTONS DURING LAP 2
    func SecondLap (on: Bool){
        clock = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
            guard let timepassing = self else {return}
            timepassing.timing += 1
            if self!.timing % 2 == 0 {
                self?.Left_button.backgroundColor = UIColor.green
                self?.Right_button.backgroundColor = UIColor.green
            }
            else {
                self?.Left_button.backgroundColor = UIColor.red
                self?.Right_button.backgroundColor = UIColor.red
            }
        })
    }
    
    //FUNCTION: RESET VARIABLES, GO BACK TO MAIN MENU
    func Reset(sender: UIButton) {
        State = 0
        timer1.invalidate()
        timer3.invalidate()
        timer4.invalidate()
        clock.invalidate()
        TimerOn3 = false
        lap2 = false
        Duration3 = 0
        counter = 0
        DispatchBool1 = false
        DispatchBool2 = false
        timer_label.text = "0"
        speed_label.text = " "
        PostType = false
        dismiss(animated: true, completion: nil)
    }
}
