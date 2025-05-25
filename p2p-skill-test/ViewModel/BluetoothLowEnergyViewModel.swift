//
//  BluetoothLowEnergyViewModel.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 24/05/25.
//

import Foundation
import CoreBluetooth

class BluetoothLowEnergyViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    @Published var isBluetoothOn = false
    @Published var peripherals = [Peripheral]()
    @Published var connectedPeripheral: UUID?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // called when the state of the central manager is updated
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isBluetoothOn = central.state == .poweredOn
        if isBluetoothOn {
            startScanning()
        } else {
            stopScanning()
        }
    }
    
    // called to discover peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown Device", rssi: RSSI.intValue) // get peripheral data
        
//        print("peripherals : \(peripheral)\n")
//        
//        if !peripherals.contains(where: { $0.id == newPeripheral.id }) { // check if data is not in the list
//            print("\(newPeripheral.id)")
//            DispatchQueue.main.async {
//                self.peripherals.append(newPeripheral)
//            }
//        }
        
        DispatchQueue.main.async {
            if let index = self.peripherals.firstIndex(where: {$0.id == newPeripheral.id}) {
                self.peripherals.removeAll(where: {$0.id == newPeripheral.id})
                self.peripherals.insert(newPeripheral, at: index)
            } else {
                self.peripherals.append(newPeripheral)
            }
        }
    }
    
    func startScanning() {
        print("hit a")
        isBluetoothOn = true
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        print("hit b")
        isBluetoothOn = false
        centralManager.stopScan()
    }
}
