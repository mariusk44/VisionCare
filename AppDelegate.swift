//
//  AppDelegate.swift
//  VisionCare
//
//  Created by mariusk44 on 2020-02-13.
//  Copyright © 2020 mariusk44. All rights reserved.
//

// MARK: Constants
let time = 20 // Default time 20 minutes
let paused = "👁️ Paused"
let startTitle = "Start"
let pauseTitle = "Pause"

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: Variables
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var window: NSWindow!
    var windows = [NSWindowController()]
    var timer: Timer?
    var isPaused: Bool = false
    var breaks = BreaksWithoutSkipping()

    var timeLeft: Int = time {
        didSet {
            self.statusItem.button?.title = "👁️ \(timeLeft)m"
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        makeStatusMenu()
        startTimer()
        addNotificationObservers()
//        openWindowForEachScreen() // Uncomment to test a Contentview
    }

    func addNotificationObservers() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil) { [unowned self] _ in self.startTimer() }
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil) { [unowned self] _ in self.stopTimer() }
        notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: nil) { [unowned self] _ in self.stopTimer() }
    }

    // MARK: Menubar
    func makeStatusMenu() {
        statusItem.button?.title = "👁️ \(timeLeft)m"
        statusItem.menu = NSMenu()
        addTogglePauseTimerMenuItem()
        addQuitAppMenuItem()
    }

    func addTogglePauseTimerMenuItem() {
        statusItem.menu?.addItem(togglePauseMenuItem)
    }

    func addQuitAppMenuItem() {
        let separator = NSMenuItem(title: "Quit", action: #selector(terminateApp), keyEquivalent: "")
        statusItem.menu?.addItem(separator)
    }

    lazy var togglePauseMenuItem: NSMenuItem = {
        return NSMenuItem(title: pauseTitle, action: #selector(togglePause), keyEquivalent: "")
    }()

    // MARK: Menubar functions
    @objc func openWindowForEachScreen() {
        breaks.increase()

        _ = NSScreen.screens.map {
            createNewWindowFor(screen: $0.frame)
        }
    }

    @objc func terminateApp() {
        NSApplication.shared.terminate(nil)
    }

    // MARK: Manage timer
    func startTimer() {
        timeLeft = time
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { [unowned self] _ in
            self.timeLeft -= 1
            if self.timeLeft == 0 {
                self.openWindowForEachScreen()
                self.timeLeft = time
            }
        })
        timer?.tolerance = 0.1
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        self.statusItem.button?.title = paused
    }

    @objc func togglePause() {
        _ = isPaused ? startTimer() : stopTimer()
        togglePauseMenuItem.title = isPaused ? pauseTitle : startTitle
        isPaused.toggle()
    }

    // MARK: Manage windows
    func createNewWindowFor(screen: NSRect) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: screen,
            styleMask: [.borderless],
            backing: .buffered, defer: false)
        window!.titlebarAppearsTransparent = true
        window!.toolbar?.isVisible = false
        window!.titleVisibility = .hidden
        window!.level = .mainMenu + 1
        window!.contentView = NSHostingView(rootView: contentView)
        window!.makeKeyAndOrderFront(true)
        // Create the window controller and append it array
        let windowController = NSWindowController(window: window)
        windows.append(windowController)
    }

    func closeAllWindows() {
        _ = self.windows.map { $0.close() }
        windows.removeAll()
    }

    // MARK: AppDelegate functions
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
