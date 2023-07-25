//
//  FlowLayout.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/17/23.
//

import SwiftUI

struct FlowLayout<B, T: Hashable & Equatable, V: View>: View {
//    private let user = UserObservable.shared
//    private let listOfGames = ListOfGames.name
//    private var gamesArray: [String] {
//        return user.listOfGames ?? []
//    }
    let mode: Mode
    @Binding var binding: B
    let items: [T]
    let viewMapping: (T) -> V
//    @State var conformationImage: Image? = Image("circle")
    
    @State private var totalHeight: CGFloat
    
    init(mode: Mode, binding: Binding<B>, items: [T], viewMapping: @escaping (T) -> V) {
        self.mode = mode
        _binding = binding
        self.items = items
        self.viewMapping = viewMapping
        _totalHeight = State(initialValue: (mode == .scrollable) ? .zero : .infinity)
    }
    
    var body: some View {
        let stack = VStack {
            GeometryReader { geometry in
                self.content(in: geometry)
            }
        }
        return Group {
            if mode == .scrollable {
                stack.frame(height: totalHeight)
            } else {
                stack.frame(maxHeight: totalHeight)
            }
        }
    }
    
    private func content(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                //                let itemContainsValue = gamesArray.firstIndex(where: { $0 == item as! String }) != nil
                HStack {
//                    if let conformationImage = conformationImage {
//                        conformationImage
//                            .padding([.horizontal, .vertical], -3)
//                            .alignmentGuide(.leading, computeValue: { d in
//                                if (abs(width - d.width) > g.size.width) {
//                                    width = 0
//                                    height -= d.height
//                                }
//                                let result = width
//                                if item == self.items.last {
//                                    width = 0
//                                } else {
//                                    width -= d.width
//                                }
//                                return result
//                            })
//                            .alignmentGuide(.top, computeValue: { d in
//                                let result = height
//                                if item == self.items.last {
//                                    height = 0
//                                }
//                                return result
//                            })
//                    }
                    self.viewMapping(item)
                        .padding([.horizontal, .vertical], -3)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width) {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == self.items.last {
                                width = 0
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: { d in
                            let result = height
                            if item == self.items.last {
                                height = 0
                            }
                            return result
                        })
                    //                    .background(
                    //                        RoundedRectangle(cornerRadius: Constants.tagFlowLayoutCornerRadius)
                    //                            .border(Color.clear)
                    //                            .foregroundColor(itemContainsValue ? Color.blue : Color.lightGrey)
                    //                            .padding(4)
                    //                    )
                    //                    .foregroundColor(itemContainsValue ? Color.white : Color.black)
                }
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geo -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geo.frame(in: .local).size.height
            }
            return .clear
        }
    }
    
    enum Mode {
        case scrollable, vstack
    }
}
