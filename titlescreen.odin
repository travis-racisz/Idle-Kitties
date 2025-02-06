package main

import rl "vendor:raylib"

build_title_screen :: proc() {
	BUTTON_HEIGHT :: 100
	BUTTON_WIDTH :: 200
	background_rect := rl.Rectangle {
		x      = 0,
		y      = 0,
		height = f32(rl.GetScreenHeight()),
		width  = f32(rl.GetScreenWidth()),
	}
	rl.DrawRectangleRec(background_rect, rl.BLACK)

	// build start, load, and options buttons 
	if rl.GuiButton(
		rl.Rectangle {
			x = f32(rl.GetScreenWidth() / 2 - (BUTTON_WIDTH / 2)),
			y = f32(rl.GetScreenHeight() / 2 - BUTTON_HEIGHT - 150),
			height = BUTTON_HEIGHT,
			width = BUTTON_WIDTH,
		},
		"Start",
	) {
		screen_state.previous_screen_state = screen_state.current_screen_state
		screen_state.current_screen_state = .GAME

	}


	if rl.GuiButton(
		rl.Rectangle {
			x = f32(rl.GetScreenWidth() / 2 - (BUTTON_WIDTH / 2)),
			y = f32(rl.GetScreenHeight() / 2 - BUTTON_HEIGHT),
			height = BUTTON_HEIGHT,
			width = BUTTON_WIDTH,
		},
		"Load",
	) {
		if load_save_game() {

			screen_state.previous_screen_state = screen_state.current_screen_state
			screen_state.current_screen_state = .GAME
		}

	}

	if rl.GuiButton(
		rl.Rectangle {
			x = f32(rl.GetScreenWidth() / 2 - (BUTTON_WIDTH / 2)),
			y = f32(rl.GetScreenHeight() / 2 - BUTTON_HEIGHT + 150),
			height = BUTTON_HEIGHT,
			width = BUTTON_WIDTH,
		},
		"Options",
	) {
		screen_state.previous_screen_state = screen_state.current_screen_state
		screen_state.current_screen_state = .OPTIONS
	}

	if rl.GuiButton(
		rl.Rectangle {
			x = f32(rl.GetScreenWidth() / 2 - (BUTTON_WIDTH / 2)),
			y = f32(rl.GetScreenHeight() / 2 - BUTTON_HEIGHT + 300),
			height = BUTTON_HEIGHT,
			width = BUTTON_WIDTH,
		},
		"Exit",
	) {
		should_game_close = true
	}

}
