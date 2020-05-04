//
//  ContentView.swift
//  VisionCare
//
//  Created by mariusk44 on 2020-02-13.
//  Copyright © 2020 mariusk44. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var breaks = BreaksWithoutSkipping()
    @State var timeRemaining = 20
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            Text("\(timeRemaining)")
                .font(Font.custom("Condiment-Regular", size: 98))
                .bold()
                .foregroundColor(colorScheme == .light ? Color(.black): Color(.white))
            
            Text("Breaks without skipping \(breaks.count)")
            
            Button(action: {
                self.appDelegate.closeAllWindows()
                self.breaks.reset()
            }) {
                Text("Skip")
            }.buttonStyle(BorderlessButtonStyle())
        }
        .onReceive(timer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer.upstream.connect().cancel()
                self.appDelegate.closeAllWindows()
            }
        }
        .opacity(0.5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    var appDelegate: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
}
