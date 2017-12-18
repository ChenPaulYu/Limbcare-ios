//
//  ViewController.swift
//  BLE_Proecjt
//
//  Created by Bernie on 2017/5/20.
//  Copyright © 2017年 PaulChen. All rights reserved.
//

import CoreBluetooth
import UIKit

enum SendDataError:Error {
    case CharacteristicNotFound
}

class ViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tempSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: Timer?
    var centralManager = CBCentralManager()
    var connectPeripheral: CBPeripheral?  
    var charDictionay = [String:CBCharacteristic]()
    var countTime = 0
    var sended = false
    var fake = false
    
    @IBAction func connect(_ sender: Any) {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        if((connectPeripheral) != nil){
            centralManager.cancelPeripheralConnection(connectPeripheral!)
            stopTimer()
            
        }
    }
    
    @IBAction func sliderchange(_ sender: Any) {
        if(sended){

        }
    }
    
    @IBAction func Send(_ sender: Any) {        
    }
    
    
    @IBAction func coldAction(_ sender: Any) {
        writeData(dataTransmit: "B0")
        tempSlider.tintColor = UIColor.blue
        timeLabel.textColor = UIColor.blue
        temperatureLabel.textColor = UIColor.blue
        stopTimer()
        startTimer()
        sended = true
    }
    @IBAction func hotAction(_ sender: Any) {
        writeData(dataTransmit: "B1")
        tempSlider.tintColor = UIColor.red
        timeLabel.textColor = UIColor.red
        temperatureLabel.textColor = UIColor.red

        stopTimer()
        startTimer()
        sended = true
    }
    @IBAction func stoping(_ sender: Any) {
        stopTimer()
        countTime = 0
        tempSlider.tintColor = UIColor.black
        timeLabel.textColor = UIColor.black
        temperatureLabel.textColor = UIColor.black

        sended = false
        timeLabel.text = "00:0"+String(countTime)
        
        writeData(dataTransmit: "T255")
    }
    
    @IBAction func cycle(_ sender: Any) {
        //random number
        let rand = Int(arc4random_uniform(50))
        let randnum = (Float(rand)/100)
        print(randnum)
        fake = true
        startTimer()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        
        tempSlider.tintColor = UIColor.blue
        timeLabel.textColor = UIColor.blue
        temperatureLabel.textColor = UIColor.blue
        
        
        let queue = DispatchQueue.global()
        centralManager = CBCentralManager(delegate: self, queue: queue)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else {
            print("Not connected")
            return
        }
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        
        var ScanDevice = peripheral.name as? String
        print(" 找到藍牙裝置: \(ScanDevice)")
        guard  peripheral.name == "Limbcare" else {
            return
        }
        
        central.stopScan()
        
        connectPeripheral = peripheral
        connectPeripheral?.delegate = self
        central.connect(peripheral, options: nil)
        var connectDevice = connectPeripheral?.name as! String
        
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("here")
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("ERROR: \(error)")
            return
        }
        for service in peripheral.services!{
            connectPeripheral?.discoverCharacteristics(nil, for: service)
            let alert = UIAlertController(title: "連接", message: "藍牙已連接", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "確認", style: .default) { action in
            })
            self.present(alert, animated: true)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("ERROR: \(error)")
            return
        }
        for characteristic in service.characteristics!{
            let uuidString = characteristic.uuid.uuidString
            charDictionay[uuidString] = characteristic
            
            if(uuidString == "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"){
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
            if(uuidString == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"){
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("get")
        guard error == nil else{
            print("ERROR:\(error)")
            return
        }
        
        if characteristic.uuid.uuidString == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"{
            
            let data = characteristic.value as! NSData
            var result = processData(data: data)
            DispatchQueue.main.async() {
                if(!self.fake){
                    self.temperatureLabel.text = String(result)+"度"
                }
            }
            
            print(result)
            
            
        }
    }
    
    func centralManager(_: CBCentralManager, didDisconnectPeripheral: CBPeripheral, error: Error?){
        
    }
    
    
    func writeData(dataTransmit: String){
        let data = dataTransmit.data(using: .utf8)
        do {
            try sendData(data: data!, uuidString: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
        }catch{
            print(error)
        }
    }
    
    
    func sendData(data:Data,uuidString:String) throws {
        guard let characteristic = charDictionay[uuidString] else {
            throw SendDataError.CharacteristicNotFound
        }
        
        if uuidString == "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"{
            
            connectPeripheral?.writeValue(data, for: characteristic,type:.withoutResponse)
        }
    }
    
    func processData(data:NSData)->Double {
        let dataLength = data.length / MemoryLayout<UInt8>.size
        var dataArray = [UInt8](repeating: 0, count:dataLength)
        data.getBytes(&dataArray, length: dataLength * MemoryLayout<Int8>.size)
        var arrayLen = dataArray.count-1
        var result = 0.0;
        var order = 100.0;
        
        print(dataArray)
        
        
        for index in 0...arrayLen{

            var number = Double(dataArray[index])-48
            if(number == -2){
                continue
            }else{
                order = Double(order*0.1);
            }
            result = (result + (order*number))as! Double
        }
        
        
        return result
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countingTimer), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timer != nil {
            print("stop")
            timer?.invalidate()
            timer = nil
            if((connectPeripheral) != nil){
                countTime = 0
            }
            

        }
    }
    
    func countingTimer(){
        countTime += 1
        print(countTime)
        
        if(fake){
            fakeNumber()
        }
        
        if(countTime == 60){
            stopTimer()
        }
        if(countTime<10){
            timeLabel.text = "00:0"+String(countTime)
        }else{
            timeLabel.text = "00:"+String(countTime)
        }
        
    }
    
    func getRandNum() -> Float {
        let rand = Int(arc4random_uniform(50))
        let randnum = (Float(rand)/100)
        return randnum
    }
    
    
    func fakeNumber () {
        var currentTemp = Float()
        if(temperatureLabel.text == "溫度值"){
            currentTemp = 25.62
        }else{
            var temp = String(temperatureLabel.text!.characters.dropLast(1))
            currentTemp = Float(temp)!
        }
        
        if(timeLabel.textColor == UIColor.blue){
            
            currentTemp -= getRandNum()
            temperatureLabel.text = String(currentTemp)+"度"
            
        }else if(timeLabel.textColor == UIColor.red){
            currentTemp += getRandNum()
            temperatureLabel.text = String(currentTemp)+"度"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

