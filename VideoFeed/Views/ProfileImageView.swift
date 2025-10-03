//
//  ProfileView.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/2/25.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    let imageName: String
    var size: CGFloat = 50
    var borderWidth: CGFloat = 2
    var borderColor: Color = .white
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0.0))
                .accessibilityLabel("Image for avatar")
            
            Text("Pikachu")
                .foregroundStyle(.white)
                .font(Font.system(size: 16.0))
                .fontWeight(.medium)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0.0))
                .accessibilityLabel("Profile name")
            
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.white)
                .accessibilityLabel("Image for Verified User")
            Spacer()
        }
    }
}
