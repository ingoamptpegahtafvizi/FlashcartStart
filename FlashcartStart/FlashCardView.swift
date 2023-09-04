import SwiftUI
import AVFoundation


struct FlashCardView: View {
    @Binding var flashCard: FlashCard
    var backgroundColor: Color

    @State private var flipped: Bool = false

    var body: some View {
        VStack {
            if flipped {
                VStack {
                    Text(flashCard.translation)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                        .minimumScaleFactor(0.5) // Ensure the text scales down if too large
                    Button(action: {
                        let utterance = AVSpeechUtterance(string: flashCard.translation)
                        utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
                        let synthesizer = AVSpeechSynthesizer()
                        synthesizer.speak(utterance)
                    }) {
                        Image(systemName: "speaker.wave.2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding()
                    }
                }
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            } else {
                VStack {
                    Image(flashCard.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                    Text(flashCard.word)
                        .font(.title2)
                        .padding()
                }
            }
        }
        .frame(width: 250, height: 350)
        .background(backgroundColor)
        .cornerRadius(20)
        .shadow(radius: 8)
        .border(Color.black, width: 2)
        .padding()
        .rotation3DEffect(
            .degrees(flipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .onTapGesture {
            withAnimation {
                flipped.toggle()
                if flipped {
                    // Pronounce the translation when the card is flipped to the translation side
                    let utterance = AVSpeechUtterance(string: flashCard.translation)
                    utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }
            }
        }
    }
}
