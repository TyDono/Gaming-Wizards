//
//  Debouncer.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/12/23.
//

import Foundation

class Debouncer {
    let delay: TimeInterval
    var timer: Timer?

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func schedule(action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
}
