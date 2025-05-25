//
//  ContentView.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 23/05/25.
//

import Foundation
import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject var bluetoothViewModel = BluetoothLowEnergyViewModel()
    @State var showPopup = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                List(bluetoothViewModel.peripherals) { peripheral in
                    NavigationLink(destination: DetailBluetoothView(dataperipheral: peripheral.id)) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(peripheral.name)
                                .font(.system(size: 14, weight: .bold))
                            Text(peripheral.id.uuidString)
                        }
                    }
                }
                .navigationTitle(Text("Discoverable Devices"))
                
                Spacer()
                
                HStack {
                    Text(bluetoothViewModel.isBluetoothOn ? "Searching Devices..." : "Searching Stopped")
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    Button {
                        if bluetoothViewModel.isBluetoothOn {
                            bluetoothViewModel.stopScanning()
                        } else {
                            bluetoothViewModel.startScanning()
                        }
                    } label: {
                        if bluetoothViewModel.isBluetoothOn {
                            Text("Stop")
                        } else {
                            Text("Start")
                        }
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding(.all, 10)
                    .background(bluetoothViewModel.isBluetoothOn ? .red : .green)
                    .cornerRadius(10)
                    .padding(.trailing, 30)
                }
                
                Spacer()
                
            }
            .onAppear {
                if bluetoothViewModel.isBluetoothOn {
                    bluetoothViewModel.startScanning()
                }
            }
            .onDisappear {
                bluetoothViewModel.stopScanning()
            }
        }
        
    }
}
