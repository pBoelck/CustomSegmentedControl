import SwiftUI

struct ContentView: View {
	@Binding private var selectedIndex: Int

	@State private var frames: Array<CGRect>
	@State private var backgroundFrame = CGRect.zero
	@State private var isScrollable = true

	private let titles: [String]

	init(selectedIndex: Binding<Int>, titles: [String]) {
		self._selectedIndex = selectedIndex
		self.titles = titles
		frames = Array<CGRect>(repeating: .zero, count: titles.count)
	}

	var body: some View {
		VStack {
			if isScrollable {
				ScrollView(.horizontal, showsIndicators: false) {
					SegmentedControlButtonView(selectedIndex: $selectedIndex, frames: $frames, backgroundFrame: $backgroundFrame, isScrollable: $isScrollable, checkIsScrollable: checkIsScrollable, titles: titles)
				}
			} else {
				SegmentedControlButtonView(selectedIndex: $selectedIndex, frames: $frames, backgroundFrame: $backgroundFrame, isScrollable: $isScrollable, checkIsScrollable: checkIsScrollable, titles: titles)
			}
		}
		.background(
			GeometryReader { geoReader in
				Color.clear.preference(key: RectPreferenceKey.self, value: geoReader.frame(in: .global))
					.onPreferenceChange(RectPreferenceKey.self) {
					self.setBackgroundFrame(frame: $0)
				}
			}
		)
	}

	private func setBackgroundFrame(frame: CGRect)
	{
		backgroundFrame = frame
		checkIsScrollable()
	}

	private func checkIsScrollable()
	{
		if frames[frames.count - 1].width > .zero
		{
			var width = CGFloat.zero

			for frame in frames
			{
				width += frame.width
			}

			if isScrollable && width <= backgroundFrame.width
			{
				isScrollable = false
			}
			else if !isScrollable && width > backgroundFrame.width
			{
				isScrollable = true
			}
		}
	}
}

struct CustomSegmentedView_Previews: PreviewProvider {
	@State static var selectedIndex: Int = 0

	static var previews: some View {
		let titles: [String] =
			["First",
			 "Second",
			 "Third",
			 "Fourth",
			 "Fifth",
			 "Sixth",
			 "Seventh",
			 "Eighth",
			 "Ninth",
			 "Tenth",
			 "Eleventh",
			 "Twelfth",
			 "Thirteenth",
			 "Fourteenth",
			 "Fifteenth",
			 "Sixteenth",
			 "Seventeenth",
			 "Eighteenth",
			 "Nineteenth",
			 "Tweentieth"
			]

		Group
		{
			ContentView(selectedIndex: $selectedIndex, titles: titles)
				.previewDevice("iPad Pro (11-inch) (3rd generation)")

			ContentView(selectedIndex: $selectedIndex, titles: titles)
				.preferredColorScheme(.dark)
				.previewDevice("iPhone 11")
		}
	}
}

private struct SegmentedControlButtonView: View {
	@Binding private var selectedIndex: Int
	@Binding private var frames: [CGRect]
	@Binding private var backgroundFrame: CGRect
	@Binding private var isScrollable: Bool

	private let titles: [String]
	let checkIsScrollable: (() -> Void)

	init(selectedIndex: Binding<Int>, frames: Binding<[CGRect]>, backgroundFrame: Binding<CGRect>, isScrollable: Binding<Bool>, checkIsScrollable: (@escaping () -> Void), titles: [String])
	{
		_selectedIndex = selectedIndex
		_frames = frames
		_backgroundFrame = backgroundFrame
		_isScrollable = isScrollable

		self.checkIsScrollable = checkIsScrollable
		self.titles = titles
	}

	var body: some View {
		HStack(spacing: 0) {
			ForEach(titles.indices, id: \.self) { index in
				Button(action:{ selectedIndex = index })
				{
					HStack {
						Text(titles[index])
							.frame(height: 42)
					}
				}
				.buttonStyle(CustomSegmentButtonStyle())
				.background(
					GeometryReader { geoReader in
						Color.clear.preference(key: RectPreferenceKey.self, value: geoReader.frame(in: .global))
							.onPreferenceChange(RectPreferenceKey.self) {
								self.setFrame(index: index, frame: $0)
							}
					}
				)
			}
		}
		.modifier(UnderlineModifier(selectedIndex: selectedIndex, frames: frames))
	}

	private func setFrame(index: Int, frame: CGRect) {
		self.frames[index] = frame

		checkIsScrollable()
	}
}

private struct CustomSegmentButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration
			.label
			.padding(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
			.background(configuration.isPressed ? Color(red: 0.808, green: 0.831, blue: 0.855, opacity: 0.5): Color.clear)
	}
}
