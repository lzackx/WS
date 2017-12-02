//
//  ClientViewController.swift
//  WS
//
//  Created by lzackx on 2017/12/2.
//  Copyright © 2017年 lzackx. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ClientViewController: UIViewController {
    
    @IBOutlet weak var tfHost: UITextField!
    @IBOutlet weak var tfPort: UITextField!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var tvInfo: UITextView!
    
    var socket: GCDAsyncSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addText(text: String) {
        tvInfo.text = tvInfo.text.appendingFormat("%@\n", text)
    }

    @IBAction func connect(_ sender: UIButton) {
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try socket!.connect(toHost: tfHost.text!, onPort: UInt16(tfPort.text!)!)
            addText(text: "Connecting...")
        }catch _ {
            addText(text: "Connection failed")
        }
        
    }
    
    @IBAction func disconnect(_ sender: UIButton) {
        
        socket!.disconnect()
        addText(text: "Disconnected")
    }
    
    @IBAction func send(_ sender: UIButton) {
        socket!.write((tfMessage.text!.data(using: String.Encoding.utf8))!, withTimeout: -1, tag: 0)
    }
}
extension ClientViewController: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
        addText(text: "Connected to server: " + host)
        addText(text: "Connected port: " + port.description)
        self.socket!.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        let msg = String(data: data, encoding: String.Encoding.utf8)
        addText(text: msg!)
        socket!.readData(withTimeout: -1, tag: 0)
    }
    
}
