//
//  DismissView.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import SwiftUI

struct DismissView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Spacer()
            Button("Close") {
                dismiss()
            }
            .tint(.purple)
            .padding(.trailing, 12)
        }
        .buttonStyle(.bordered)
    }
}

struct DismissView_Previews: PreviewProvider {
    static var previews: some View {
        DismissView()
    }
}
