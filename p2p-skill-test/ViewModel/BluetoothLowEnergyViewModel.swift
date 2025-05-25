//
//  BluetoothLowEnergyViewModel.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 24/05/25.
//

import Foundation
import CoreBluetooth
import SwiftUI

class BluetoothLowEnergyViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    @Published var isBluetoothOn = false
    @Published var peripherals = [Peripheral]()
    @Published var connectedPeripheral: Peripheral?
    @Published var peripheralFound: Peripheral!
    @Published var serviceName : String = " "
    @Published var charsName: String = "..."
    @Published var characteristicNameStr: String = "-"
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isBluetoothOn = central.state == .poweredOn
        if isBluetoothOn {
            startScanning()
        } else {
            stopScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheralFound = Peripheral(
            _peripheral: peripheral,
            _services: [],
            _name: peripheral.name ?? "Unknown name",
            _rssi: RSSI.intValue
        )
        
        DispatchQueue.main.async {
            if !self.isInFoundPeripherals(self.peripheralFound) {
                self.peripherals.append(self.peripheralFound)
            }
        }
    }
    
    func isInFoundPeripherals (_ onePeripheral: Peripheral) -> Bool {
        for item in peripherals {
            if item.peripheral.identifier.uuidString == onePeripheral.peripheral.identifier.uuidString {
                return true
            }
        }
        return false
    }
    
    func startScanning() {
        isBluetoothOn = true
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        isBluetoothOn = false
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("conected")
        peripheral.delegate = self;
        
        connectedPeripheral = Peripheral(
            _peripheral: peripheral,
            _services: [],
            _name: peripheral.name ?? "not provided name",
            _rssi: peripheralFound.rssi
        )
        
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnected")
        resetConfigure()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach { oneService in
            let serName = getServiceName(serviceDescription: oneService.description)
            serviceName = serName
            
            let foundOneService: PeripheralService = PeripheralService (
                _uuid: oneService.uuid,
                _service: oneService,
                _serviceName: serName,
                _characteristices: []
            )
            
            let oneUserPeripheralService: PeripheralService = PeripheralService (
                _uuid: foundOneService.uuid,
                _service: foundOneService.service,
                _serviceName: serName,
                _characteristices: []
            )
            
            connectedPeripheral?.services.append(oneUserPeripheralService)
            peripheral.discoverCharacteristics(nil, for: foundOneService.service)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach { characteristic in
            
            peripheral.discoverDescriptors(for: characteristic)
            peripheral.readValue(for: characteristic)
            
            let foundOneUserChar : PeripheralCharacteristic = PeripheralCharacteristic(
                _characteristic: characteristic,
                _uuid: characteristic.uuid,
                _characteristicName: characteristicNameStr
            )
            
            for item in connectedPeripheral?.services ?? [] {
                if item.uuid.uuidString == service.uuid.uuidString {
                    item.characteristices.append(foundOneUserChar)
                }
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else { return }
        
        if let userDescriptionDescriptor = descriptors.first(where: {
            return $0.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString}
        ) {
            for oneService in connectedPeripheral?.services ?? [] {
                for oneChar in oneService.characteristices {
                    if oneChar.uuid.uuidString == characteristic.uuid.uuidString {
                        oneChar.characteristicName = userDescriptionDescriptor.value as? String ?? " "
                        charsName = oneChar.characteristicName
                    }
                }
            }
            
        } else {
            
            for oneService in connectedPeripheral?.services ?? [] {
                for oneChar in oneService.characteristices {
                    let charsName = getPredefineCharacteristicName(charsUuidStr: oneChar.uuid.uuidString)
                    if( charsName != "NO_CHARS_NAME") {
                        oneChar.characteristicName  = charsName
                    }
                }
            }
            
        }
        
    }
    
    func getPredefineCharacteristicName(charsUuidStr: String) -> String {
        let predefineCharsName = [
            "2A29": "Manufacturer Name String",
            "2A24": "Model Number String",
            "2A25": "Serial Number String",
            "2A26": "Firmware Revision String",
            "2A27": "Hardware Revision String",
            "2A39": "Heart Rate Control Point",
            "2A8D": "Heart Rate Max",
            "2A37": "Heart Rate Measurement"
        ]
        
        let charsName = findCharsName(for: charsUuidStr, in: predefineCharsName)
        return charsName
    }
    
    func findCharsName(for contact: String, in dictionary: [String: String]) -> String {
        guard let charsName = dictionary[contact] else {
            return "NO_CHARS_NAME"
        }
        
        return charsName
    }
    
    func getServiceName(serviceDescription: String) -> String {
        let target = "UUID = "
        
        if let range = serviceDescription.range(of: target) {
            let uuidRange = range.upperBound..<serviceDescription.endIndex
            var serviceName = String(serviceDescription[uuidRange])
            
            if serviceName.hasSuffix(">") {
                serviceName.removeLast()
            }
            return serviceName;
            
        } else {
            return " "
        }
        
    }
    
    func resetConfigure() {
        withAnimation { connectedPeripheral = nil }
    }
}
