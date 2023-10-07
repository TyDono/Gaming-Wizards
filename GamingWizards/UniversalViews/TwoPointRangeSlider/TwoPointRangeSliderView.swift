//
//  AgeSearchRangeSliderView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/7/23.
//

import SwiftUI

struct TwoPointRangeSliderView: View {
    @StateObject var twoPointRangeSliderVM: TwoPointRangeSliderViewModel
    
    init(twoPointRangeSliderVM: TwoPointRangeSliderViewModel = TwoPointRangeSliderViewModel()) {
        self._twoPointRangeSliderVM = StateObject(wrappedValue: twoPointRangeSliderVM)
    }
    
    var body: some View {
        Text("-_-")
    }
    
}
