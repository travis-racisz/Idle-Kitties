package main
import rl "vendor:raylib"

build_options_screen :: proc() {
	rl.DrawRectangleRec(
		rl.Rectangle {
			x = 0,
			y = 0,
			height = f32(rl.GetScreenHeight()),
			width = f32(rl.GetScreenWidth()),
		},
		rl.BLACK,
	)

	slider := rl.Rectangle {
		x      = f32(rl.GetScreenWidth() / 2 - 500),
		y      = f32(rl.GetScreenHeight() / 2 - 100),
		height = 100,
		width  = 1000,
	}

	// build options like music volume
	music_volume_slider := rl.GuiSliderBar(slider, "Music Volume", "100", &music_volume, 0, 1)
	rl.SetSoundVolume(music, music_volume)
	if rl.GuiButton(rl.Rectangle{x = 100, y = 50, height = 100, width = 200}, "Back") {

		screen_state.current_screen_state = screen_state.previous_screen_state
		screen_state.previous_screen_state = .OPTIONS
	}

	save_game := rl.Rectangle {
		x      = f32(rl.GetScreenWidth() / 2 - 100),
		y      = f32(rl.GetScreenHeight() / 2 + 200),
		height = 100,
		width  = 200,
	}

	if rl.GuiButton(save_game, "Save Game") {
		create_save_game(&world)
	}

	if rl.GuiButton(
		rl.Rectangle {
			x = f32(rl.GetScreenWidth() / 2 - 100),
			y = f32(rl.GetScreenHeight() / 2 + 350),
			height = 100,
			width = 200,
		},
		"Exit",
	) {
		should_game_close = true

	}


}
