//
//  DetailBluetoothView.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 25/05/25.
//

import SwiftUI
import CoreBluetooth

struct DetailBluetoothView: View {
    
    @StateObject public var peripheralSelected: Peripheral
    @StateObject public var viewModel: BluetoothLowEnergyViewModel
    @State var connectionStatus: String = "Connecting ..."
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment: .leading) {
                Text("Name: \(peripheralSelected.name)")
                    .fontWeight(.bold)
                Text("ID: \(peripheralSelected.id.uuidString)")
            }
            .padding(.horizontal, 30)
            
            Spacer().frame(height: 20)
            
            if peripheralSelected.peripheral.state == CBPeripheralState.connected {
                Text("Connected")
            } else {
                Text("\(connectionStatus)")
                
                var count = 0
                let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if (count >= 3) {
                        connectionStatus = "Cannot connect"
                        timer.invalidate()
                    }
                    count += 1
                }
            }
            
            List(
                peripheralSelected.peripheral.state == CBPeripheralState.connected ?
                (viewModel.connectedPeripheral?.services ?? []) : []
            ) { item in
                
                GroupBox(
                    label:
                        VStack(alignment:.leading) {
                            Text("Service: \(item.serviceName)")
                            Text("\(item.uuid.uuidString) \n").font(.subheadline)}
                ){
                    ForEach (item.characteristices) { charInfo in
                        Divider().padding(.vertical, 2)
                        Text("\(charInfo.characteristicName)")
                        Text("\(charInfo.uuid.uuidString) \n").font(.subheadline)
                    }
                    
                }
                
            }
        }
        .onAppear{
            viewModel.centralManager?.connect(peripheralSelected.peripheral)
        }
    }
    
    func goBack(){
        self.presentationMode.wrappedValue.dismiss()
        viewModel.centralManager?.cancelPeripheralConnection(peripheralSelected.peripheral)
    }
}
