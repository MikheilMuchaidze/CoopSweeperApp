//
//  CustomTextFieldWithErrorState.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 08.04.25.
//

import SwiftUI

struct CustomTextFieldWithErrorState: View {
    // MARK: - Private Properties

    @Binding private var text: String
    @Binding private var hasError: Bool?
    @FocusState private var focused: Bool
    private let placeholder: String
    @Environment(\.colorScheme) var colorScheme
    private var isDarkModeOn: Bool {
        colorScheme == .dark
    }

    // MARK: - Init

    init(
        text: Binding<String>,
        hasError: Binding<Bool?>?,
        placeholder: String
    ) {
        self._text = text
        self._hasError = hasError ?? Binding.constant(nil)
        self.placeholder = placeholder
    }

    // MARK: - Body

    var body: some View {
        let isActive = focused || text.count > 0

        HStack {
            ZStack(alignment: isActive ? .topLeading : .center) {
                textField(isActive: isActive)
                placeholderText(isActive: isActive)
            }
            Spacer()
            clearTextButton
        }
        .animation(.linear(duration: 0.2), value: focused)
        .frame(height: 50)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    hasError ?? false ? .red : (focused ? .black.opacity(0.6) : .black.opacity(0.2)),
                    lineWidth: hasError ?? false ? 3 : 2
                )
                .animation(.easeInOut(duration: 0.3), value: hasError)
        }
        .onTapGesture {
            focused = true
        }
        .onChange(of: hasError ?? false, { _, newValue in
            if newValue {
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                    withAnimation {
                        hasError = false
                    }
                }
            }
        })
    }
}

extension CustomTextFieldWithErrorState {
    private func textField(isActive: Bool) -> some View {
        TextField("", text: $text)
            .foregroundStyle(.black)
            .frame(height: 24)
            .font(.system(size: 16, weight: .regular))
            .opacity(isActive ? 1 : 0)
            .offset(y: 7)
            .focused($focused)
    }

    private func placeholderText(isActive: Bool) -> some View {
        HStack {
            Text(placeholder)
                .foregroundColor(.black.opacity(0.3))
                .frame(height: 16)
                .font(.system(size: isActive ? 12 : 16, weight: .regular))
                .offset(y: isActive ? -7 : 0)
            Spacer()
        }
    }

    private var clearTextButton: some View {
        Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 15, height: 15)
            .foregroundColor(.black)
            .opacity(text.isEmpty ? 0 : 1)
            .onTapGesture {
                text = ""
            }
    }
}

// MARK: - Preview

#Preview {
    struct CustomTextFieldPreview: View {
        @State private var text: String = ""
        @State private var hasError: Bool? = false
        @State private var focused: Bool = false

        var body: some View {
            VStack(spacing: 20) {
                CustomTextFieldWithErrorState(
                    text: $text,
                    hasError: $hasError,
                    placeholder: "Enter your name"
                )
                .padding()

                Button("Show Error") {
                    hasError = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }

    return CustomTextFieldPreview()
}
