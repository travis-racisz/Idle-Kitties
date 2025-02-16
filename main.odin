package main

import "core:fmt"
import "core:math/rand"
import "core:strings"
import rl "vendor:raylib"

Options :: struct {
	music_volume: f32,
}


ScreenStates :: enum {
	TITLE,
	OPTIONS,
	GAME,
}

ScreenState :: struct {
	current_screen_state:  ScreenStates,
	previous_screen_state: ScreenStates,
}

FallingCat :: struct {
	x:             i32,
	y:             i32,
	texture_index: i32,
}

options: Options
should_game_close: bool
screen_state: ScreenState
world := create_world()
camera := rl.Camera2D {
	target = rl.Vector2{0, 0},
	zoom   = 1,
	offset = {0, 0},
}

CAMERA_MAX_HEIGHT :: 0
CAMERA_MIN_HEIGHT :: -1500
FALLING_CAT_COUNT :: 100
SCREEN_TOP :: -100
FALLING_SPEED :: 5.0
MIN_X_POSITION :: 50
MAX_X_POSITION :: 750


title_cats: [FALLING_CAT_COUNT]FallingCat
title_textures: [dynamic]rl.Texture
IdleTextures :: [11]string
JumpingTextures :: [11]string
MusicTracks :: [4]cstring


music_tracks := MusicTracks {
	"./assets/music/groovy-music.mp3",
	"./assets/music/for-her-chill-upbeat-summel-travel-vlog-and-ig-music-royalty-free-use-202298.mp3",
	"./assets/music/nightfall-future-bass-music-228100.mp3",
	"./assets/music/vlog-music-beat-trailer-showreel-promo-background-intro-theme-274290.mp3",
}

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

ball_texture: rl.Texture
collect_sound: rl.Sound
music: rl.Sound
random_song: rl.Sound
music_volume: f32


main :: proc() {
	screen_state = ScreenState {
		current_screen_state  = .TITLE,
		previous_screen_state = .TITLE,
	}
	should_game_close = false
	rl.InitWindow(rl.GetScreenHeight(), rl.GetScreenHeight(), "Idle Kitties!")
	rl.SetTargetFPS(60)

	rl.SetConfigFlags(
		{.FULLSCREEN_MODE, .WINDOW_RESIZABLE, .WINDOW_UNDECORATED, .WINDOW_MAXIMIZED},
	)
	defer rl.CloseWindow()

	read_config_file()
	rl.GuiLoadStyle("./assets/candy.rgs")
	init_audio()
	initialize_cats()
	init_title_cats()
	init_background()
	defer write_config_file()

	ball_texture = rl.LoadTexture("./assets/CatMaterialsDEMO/CatMaterialsDEMO/BlueBall.gif")
	for !should_game_close {


		mouse_pos := rl.GetMousePosition()
		rl.BeginDrawing()


		if !rl.IsSoundPlaying(music) {
			song_index := rand.int31_max(4)
			music = rl.LoadSound(music_tracks[song_index])
			rl.PlaySound(music)
			rl.SetSoundVolume(music, options.music_volume)

		}


		switch screen_state.current_screen_state {
		case .TITLE:
			build_title_screen()
			update_title_cats()
			render_title_cats()
		case .OPTIONS:
			build_options_screen()
			update_success_message()
			render_success_message()
		case .GAME:
			rl.ClearBackground(rl.GRAY)

			update_background()
			render_background()
			rl.BeginMode2D(camera)
			if rl.IsKeyPressed(.ESCAPE) {
				screen_state.previous_screen_state = screen_state.current_screen_state
				screen_state.current_screen_state = .OPTIONS
			}
			scroll := rl.GetMouseWheelMove()
			if scroll < 0 {
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


			render_system(&world)
			render_buttons_system(&world)


			for entity in world.storage.entities {
				unlocked, ok := world.storage.unlocked[entity]
				if ok {
					movement_system(&world, entity)
				}
			}
			score_text := strings.clone_to_cstring(fmt.tprintf("points: %d", world.global_points))
			rl.DrawText(score_text, i32(100), i32(camera.offset.y * -1) + 50, 60, rl.BLACK)
			rl.EndMode2D()
		}

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
			PointsContributer{amount = i32((i + 1) * 2), is_active = true},
			AnimationState{state = .IDLE, current_frame = 0, animation_speed = 8},
		)
		add_buttons(&world, entity, world.storage.positions[entity].y, (i32(i) * 100))
	}


}


init_audio :: proc() {
	rl.InitAudioDevice()
	if rl.IsAudioDeviceReady() {
		collect_sound = rl.LoadSound("./assets/soft_click.wav")
		music = rl.LoadSound("./assets/music/groovy-music.mp3")
		rl.SetSoundVolume(music, options.music_volume)
	}

}


init_title_cats :: proc() {
	// Load textures once
	for texture_path in idle_textures {
		texture := rl.LoadTexture(strings.clone_to_cstring(texture_path))
		append(&title_textures, texture)
	}

	// Initialize cats with random positions
	for &cat, i in &title_cats {
		cat.x = i32(rand.int31_max(i32(rl.GetScreenWidth()) - 50))
		cat.y = -i32(rand.int31_max(1000)) // Random starting heights
		cat.texture_index = i32(rand.int31_max(i32(len(title_textures))))
	}
}

update_title_cats :: proc() {
	FALL_SPEED :: 2
	for &cat in &title_cats {
		cat.y += FALL_SPEED

		// Reset to top when cat reaches bottom
		if cat.y > rl.GetScreenHeight() {
			cat.y = -50
			cat.x = i32(rand.int31_max(i32(rl.GetScreenWidth()) - 50))
			cat.texture_index = i32(rand.int31_max(i32(len(title_textures))))
		}
	}
}

render_title_cats :: proc() {
	for cat in title_cats {
		texture := title_textures[cat.texture_index]
		rl.DrawTextureRec(
			texture,
			{x = 0, y = 0, height = f32(texture.height), width = f32(texture.width / 7)},
			{f32(cat.x), f32(cat.y)},
			rl.WHITE,
		)
	}
}
