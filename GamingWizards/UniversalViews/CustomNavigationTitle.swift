//
//  CustomNavigationTitle.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/2/23.
//

import Foundation
import SwiftUI

struct CustomNavigationTitle: View {
    var leadingButtonAction: (() -> Void)?
    var trailingButtonAction: (() -> Void)?
    @Binding var leadingButtonString: String?
    @Binding var trailingButtonString: String?
    @Binding var titleImageSystemName: String?
    @Binding var titleText: String?
    
    var body: some View {
        HStack {
            
            HStack {
                if let leadingButtonString = leadingButtonString, let leadingButtonAction = leadingButtonAction {
                    Button(action: leadingButtonAction) {
                        Image(systemName: leadingButtonString)
                            .imageScale(.large)
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .padding(.leading, -5)
            
//            Spacer()
            HStack(alignment: .center) {
                if let titleImageSystemName = titleImageSystemName {
                    Image(systemName: titleImageSystemName)
                        .imageScale(.large)
                }
                if let titleText = titleText {
                    Text(titleText)
                        .font(.globalFont(.luminari, size: 28))
                        .foregroundStyle(Color.black)
                }
            }
            .padding()
            
//            Spacer()
            HStack {
                if let trailingButtonString = trailingButtonString, let trailingButtonAction = trailingButtonAction {
                    Button(action: trailingButtonAction) {
                        Image(systemName: trailingButtonString)
                            .imageScale(.large)
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .padding(.trailing, -5)
        }
    }
}

struct UCustomNavigationTitle_Previews: PreviewProvider {
    static var previews: some View {
        @State var leadingButtonString: String? = "xmark"
        @State var trailingButtonString: String? = "exclamationmark.shield"
        @State var titleImageSystemName: String? = "person"
        @State var titleText: String? = "title text"
        CustomNavigationTitle(leadingButtonAction: {
            print("leading tapped")
        },
                              trailingButtonAction: {
            print("trailing tapped")
        },
                              leadingButtonString: $leadingButtonString,
                              trailingButtonString: $trailingButtonString,
                              titleImageSystemName: $titleImageSystemName,
                              titleText: $titleText)
    }
}
