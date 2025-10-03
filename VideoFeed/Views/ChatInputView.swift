//
//  ChatInputView.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/2/25.
//

import SwiftUI

struct MessageTextView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    @Binding var isTyping : Bool
    
    var maxLines: Int = 6
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MessageTextView
        
        init(_ parent: MessageTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            MessageTextView.recalculateHeight(view: textView, result: &parent.dynamicHeight, maxLines: self.parent.maxLines)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isTyping = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isTyping = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.cornerRadius = 20.0
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        DispatchQueue.main.async {
            MessageTextView.recalculateHeight(view: uiView, result: &dynamicHeight, maxLines: maxLines)
        }
        
    }
    
    private static func recalculateHeight(view: UITextView, result: inout CGFloat, maxLines: Int) {
        guard let font = view.font else { return }
        let lineHeight = font.lineHeight
        let maxHeight = lineHeight * CGFloat(maxLines)
        
        let size = view.sizeThatFits(CGSize(width: view.bounds.width, height: CGFloat.infinity))
        let clampedHeight = min(size.height, maxHeight)
        
        if result != clampedHeight {
            result = clampedHeight
            view.isScrollEnabled = size.height > maxHeight
        }
    }
}

struct ChatInputView: View {
    @Binding var message: String
    @Binding var textViewHeight: CGFloat
    @Binding var isTyping: Bool
    
    var body: some View {
        HStack(alignment: .bottom) {
            MessageTextView(text: $message, dynamicHeight: $textViewHeight, isTyping: $isTyping)
                .frame(height: textViewHeight)
                .background(.clear)
                .cornerRadius(20.0)
                .accessibilityLabel("Message Text Editor")
        }
    }

}
