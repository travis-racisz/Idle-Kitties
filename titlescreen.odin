package main

import clay "clay/bindings/odin/clay-odin"


build_title_screen :: proc() {
	clay.Text("Test", clay.TextConfig({fontSize = 20, textColor = clay.Color{2, 32, 82, 255}}))

}
