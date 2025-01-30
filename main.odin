package main

import rl "vendor:raylib"
world := create_world()
player := create_entity(&world, 0)

main :: proc() {
	rl.InitWindow(rl.GetScreenHeight(), rl.GetScreenHeight(), "Run Back Experiment")
	defer rl.CloseWindow()
	add_position(&world, player, {10, 10})
	add_sprite(
		&world,
		player,
		{rl.LoadTexture("./assets/AllCatsDemo/AllCatsDemo/BatmanCatFree/IdleCatt 2.png")},
	)
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()


		rl.ClearBackground(rl.BLACK)
		defer rl.EndDrawing()

	}


}
