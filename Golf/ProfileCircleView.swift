//
//  SwiftUIView.swift
//  Golf
//
//  Created by Nick Walter on 6/20/23.
//

import SwiftUI

struct ProfileCircleView: View {
    @Binding var emoji: String
    
    var body: some View {
        Text(String(emoji.first ?? "🏋️‍♀️"))
            .font(.system(size: 40))
            .padding()
            .background(.tertiary)
            .clipShape(Circle())
    }
}

#Preview {
    ProfileCircleView(emoji: .constant("🌺"))
}
