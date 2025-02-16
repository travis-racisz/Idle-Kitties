package main

import "core:math/rand"
import "core:strings"
import rl "vendor:raylib"

has_spawned_cats := true


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

	rl.DrawText("Idle Kitties", 200, 200, 50, rl.WHITE)
	spawn_cats()
	// build start, load, and options buttons 
	if rl.GuiButton(
		rl.Rectangle {
			x = f32(rl.GetScreenWidth() / 2 - (BUTTON_WIDTH / 2)),
			y = f32(rl.GetScreenHeight() / 2 - BUTTON_HEIGHT - 150),
			height = BUTTON_HEIGHT,
			width = BUTTON_WIDTH,
		},
		"New Game",
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


spawn_cats :: proc() {
	// spawn 100 cats at random positions and have them fall to the bottom of the screen 
	// when they reach the bottom move them back to the top to begin falling again 

	if !has_spawned_cats {

		for i in 0 ..< 100 {
			rand := rand.int31_max(9)
			cat_index := idle_textures[rand]
			entity := create_entity(&world, world.next_entity_id)
			add_cat(
				&world,
				entity,
				{x = 0, y = 0, is_returning = false},
				{0, 2},
				Sprite{idle_texture = rl.LoadTexture(strings.clone_to_cstring(cat_index))},
				true,
				PointsContributer{amount = 0, is_active = true},
				AnimationState{state = .IDLE, current_frame = 0, animation_speed = 8},
			)
			add_unlocked(&world, entity)

		}

	}

	has_spawned_cats = true
}
