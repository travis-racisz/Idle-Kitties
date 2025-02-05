package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"
world := create_world()
camera := rl.Camera2D {
	target = rl.Vector2{0, 0},
	zoom   = 1,
	offset = {0, 0},
}

CAMERA_MAX_HEIGHT :: 0
CAMERA_MIN_HEIGHT :: -1500

IdleTextures :: [11]string
JumpingTextures :: [11]string

idle_textures := IdleTextures {
	"./assets/AllCatsDemo/AllCatsDemo/BatmanCatFree/IdleCatt.png",
	"./assets/AllCatsDemo/AllCatsDemo/BlackCat/IdleCatb.png",
	"./assets/AllCatsDemo/AllCatsDemo/Brown/IdleCattt.png",
	"./assets/AllCatsDemo/AllCatsDemo/Classical/IdleCat.png",
	"./assets/AllCatsDemo/AllCatsDemo/DemonicFree/IdleCatd.png",
	"./assets/AllCatsDemo/AllCatsDemo/EgyptCatFree/IdleCatb.png",
	"./assets/AllCatsDemo/AllCatsDemo/Siamese/IdleCattt.png",
	"./assets/AllCatsDemo/AllCatsDemo/ThreeColorFree/IdleCatt.png",
	"./assets/AllCatsDemo/AllCatsDemo/TigerCatFree/IdleCatt.png",
	"./assets/AllCatsDemo/AllCatsDemo/White/IdleCatttt.png",
	"./assets/AllCatsDemo/AllCatsDemo/Xmas/Idle2Cattt.png",
}

jumping_textures := JumpingTextures {
	"./assets/AllCatsDemo/AllCatsDemo/BatmanCatFree/JumpCattt.png",
	"./assets/AllCatsDemo/AllCatsDemo/BlackCat/JumpCabt.png",
	"./assets/AllCatsDemo/AllCatsDemo/Brown/JumpCatttt.png",
	"./assets/AllCatsDemo/AllCatsDemo/Classical/JumpCat.png",
	"./assets/AllCatsDemo/AllCatsDemo/DemonicFree/JumpCatd.png",
	"./assets/AllCatsDemo/AllCatsDemo/EgyptCatFree/JumpCabt.png",
	"./assets/AllCatsDemo/AllCatsDemo/Siamese/JumpCatttt.png",
	"./assets/AllCatsDemo/AllCatsDemo/ThreeColorFree/JumpCattt.png",
	"./assets/AllCatsDemo/AllCatsDemo/TigerCatFree/JumpCattt.png",
	"./assets/AllCatsDemo/AllCatsDemo/White/JumpCattttt.png",
	"./assets/AllCatsDemo/AllCatsDemo/Xmas/JumpCatttt.png",
}

main :: proc() {
	rl.InitWindow(rl.GetScreenHeight(), rl.GetScreenHeight(), "Run Back Experiment")
	rl.SetTargetFPS(60)

	rl.SetConfigFlags({.FULLSCREEN_MODE, .WINDOW_RESIZABLE})
	defer rl.CloseWindow()

	rl.GuiLoadStyle("./assets/candy.rgs")
	world.global_points = 100000

	initialize_cats()

	//rl.SetMouseScale(.65, .655)

	for !rl.WindowShouldClose() {

		mouse_pos := rl.GetMousePosition()
		rl.BeginDrawing()

		rl.ClearBackground(rl.GRAY)

		rl.BeginMode2D(camera)
		scroll := rl.GetMouseWheelMove()
		if scroll < 0 {
			fmt.println(camera.offset.y)
			if camera.offset.y <= CAMERA_MIN_HEIGHT {
			} else {

				camera.offset -= {0.0, 40.0}
				rl.SetMouseOffset(i32(camera.offset.x), i32(-camera.offset.y))

			}

		} else if scroll > 0 {
			if camera.offset.y < CAMERA_MAX_HEIGHT {

				camera.offset += {0.0, 40.0}
				rl.SetMouseOffset(i32(camera.offset.x), i32(-camera.offset.y))
			}

		}


		boundary := rl.Rectangle {
			x      = 80,
			y      = 50,
			width  = 1100,
			height = 1100,
		}
		rl.DrawRectangleLinesEx(boundary, 3.0, rl.BLACK)


		render_system(&world)
		render_buttons_system(&world)


		for entity in world.storage.entities {
			unlocked, ok := world.storage.unlocked[entity]
			if ok {
				movement_system(&world, entity)
			}
		}
		score_text := strings.clone_to_cstring(fmt.tprintf("points: %d", world.global_points))
		rl.DrawText(score_text, 10, 10, 20, rl.WHITE)

		rl.EndMode2D()
		rl.EndDrawing()
		defer free_all(context.temp_allocator)

	}


}


add_cat :: proc(
	world: ^World,
	entity: Entity,
	position: Position,
	velocity: Velocity,
	sprite: Sprite,
	unlocked: Unlocked,
	points: PointsContributer,
	animation_state: AnimationState,
) {


	add_position(world, entity, position)
	add_velocity(world, entity, velocity)
	add_sprite(world, entity, sprite)
	add_points_contributer(world, entity, points)
	add_animation_state(world, entity, animation_state)


}

initialize_cats :: proc() {
	CAT_TOTAL :: 10
	for i in 0 ..< CAT_TOTAL {
		entity := create_entity(&world, world.next_entity_id)
		if i == 0 {
			add_unlocked(&world, entity)
		}
		add_cat(
			&world,
			entity,
			{x = 100, y = i32(100 * (i + 1)), is_returning = false},
			{2, 0},
			{
				idle_texture = rl.LoadTexture(strings.clone_to_cstring(idle_textures[i])),
				move_right_texture = rl.LoadTexture(strings.clone_to_cstring(jumping_textures[i])),
			},
			true,
			PointsContributer{amount = 1, is_active = true},
			AnimationState{state = .IDLE, current_frame = 0, animation_speed = 8},
		)
		add_buttons(&world, entity, world.storage.positions[entity].y)
	}


}
