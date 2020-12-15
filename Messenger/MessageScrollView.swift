//
//  MessageScrollView.swift
//  Messenger
//
//  Created by Zeno on 11/25/20.
//

import SwiftUI

struct MessageScrollView<Content>: View where Content: View {
    var content: () -> Content
    
    var body: some View {
        GeometryReader { outerGeometry in
            // Render the content
            //  ... and set its sizing inside the parent
            self.content()
                .frame(height: outerGeometry.size.height)
                .clipped()
        }
    }
}
