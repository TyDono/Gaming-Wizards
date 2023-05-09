//
//  SearchResultsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var searchResultsViewModel = SearchResultsViewModel()
    
    var body: some View {
        ZStack {
            Text("hiay")
        }
        
    }
    
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}
