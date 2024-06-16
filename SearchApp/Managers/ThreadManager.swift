//
//  ThreadManager.swift
//  Ronit_HiveAssignment
//
//  Created by Ronit Chaurasia on 28/05/24.
//

import Foundation

class ThreadManager{
    private let serialQueue = DispatchQueue(label: "com.hive.assignment", qos: .utility)
    private var workItem: DispatchWorkItem?
    
    func manageThread(action: @escaping () -> Void){
        workItem = DispatchWorkItem(block: action)
        
        if let workItem = workItem{
            // added delay to avoid multiple hits when user is typing or deleting too fast
            serialQueue.asyncAfter(deadline: .now() + 0.4, execute: workItem)
        }
    }
    
    func cancelWorkItem(){
        workItem?.cancel()
    }
}
