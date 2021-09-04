//
//  ContentView.swift
//  CustomSegmentedControl
//
//  Created by Boelck, Pascal on 04.09.21.
//

import SwiftUI

struct ContentView: View {
	@State var selectedIndex: Int = 0

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
	
    var body: some View {
		SegmentedControlView(selectedIndex: $selectedIndex, titles: titles)
    }
}
