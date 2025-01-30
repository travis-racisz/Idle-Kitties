package main

import "core:fmt"
import rl "vendor:raylib"
world := create_world()


main :: proc() {
	first_cat := create_entity(&world, 1)
	rl.InitWindow(rl.GetScreenHeight(), rl.GetScreenHeight(), "Run Back Experiment")
	defer rl.CloseWindow()
	add_position(&world, first_cat, {100, 100})
	add_sprite(
		&world,
		first_cat,
		{rl.LoadTexture("./assets/AllCatsDemo/AllCatsDemo/BatmanCatFree/IdleCatt.png")},
	)
	add_animation_state(
		&world,
		first_cat,
		{state = .IDLE, current_frame = 0, animation_speed = .1},
	)
	fmt.print(world)
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		render_system(&world)

		rl.ClearBackground(rl.GRAY)
		defer rl.EndDrawing()

	}


}
