//
//  ServerViewController.swift
//  WS
//
//  Created by lzackx on 2017/12/2.
//  Copyright © 2017年 lzackx. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ServerViewController: UIViewController {
    
    @IBOutlet weak var tfPort: UITextField!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var tvInfo: UITextView!
    
    var serverSocket: GCDAsyncSocket?
    var clientSocket: GCDAsyncSocket?
    
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
    
    @IBAction func listen(_ sender: UIButton) {
        
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try serverSocket!.accept(onPort: UInt16(tfPort.text!)!)
            addText(text: "Listening...")
        }catch _ {
            addText(text: "Listen failed")
        }
    }
    
    @IBAction func send(_ sender: UIButton) {
        
        let data = tfMessage.text!.data(using: String.Encoding.utf8)
        
        clientSocket!.write(data!, withTimeout: -1, tag: 0)
    }

}

extension ServerViewController: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        
        addText(text: "Connection successful")
        addText(text: "Connected host: " + newSocket.connectedHost!)
        addText(text: "Connected Port: " + String(newSocket.connectedPort))
        clientSocket = newSocket
        
        clientSocket!.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        let message = String(data: data as Data,encoding: String.Encoding.utf8)
        addText(text: message!)
        sock.readData(withTimeout: -1, tag: 0)
    }
    
}
