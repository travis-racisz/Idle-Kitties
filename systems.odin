package main
import "core:fmt"

import "core:strings"
import rl "vendor:raylib"


add_velocity :: proc(world: ^World, entity: Entity, velocity: Velocity) {
	world.storage.velocities[entity] = velocity

}

add_animation_state :: proc(world: ^World, entity: Entity, state: AnimationState) {
	world.storage.animation_states[entity] = state

}

add_position :: proc(world: ^World, entity: Entity, position: Position) {
	world.storage.positions[entity] = position

}

create_entity :: proc(world: ^World, entity: Entity) -> Entity {
	world.next_entity_id = entity
	world.next_entity_id += 1
	append(&world.storage.entities, entity)
	return entity
}

create_world :: proc() -> World {
	return World {
		next_entity_id = 0,
		storage = {
			velocities = make(map[Entity]Velocity),
			positions = make(map[Entity]Position),
			entities = make([dynamic]Entity),
			animation_states = make(map[Entity]AnimationState),
			sprites = make(map[Entity]Sprite),
		},
	}


}

add_sprite :: proc(world: ^World, entity: Entity, sprite: Sprite) {
	world.storage.sprites[entity] = sprite

}

add_unlocked :: proc(world: ^World, entity: Entity) {
	world.storage.unlocked[entity] = true
}

add_points_contributer :: proc(
	world: ^World,
	entity: Entity,
	points_contributer: PointsContributer,
) {
	world.storage.points_contributers[entity] = points_contributer
}

add_buttons :: proc(world: ^World, entity: Entity, entity_y_pos: i32) {
	buttons := make([]Button, 3)
	button_width := 100
	button_height := 30
	spacing := 50

	// Create unlock button
	buttons[0] = Button {
		rect = rl.Rectangle {
			x      = 100, // Align with entity starting position
			y      = f32(entity_y_pos + 50), // Position below entity
			width  = f32(button_width),
			height = f32(button_height),
		},
		cost = 100,
		type = .UNLOCK,
	}

	// Create upgrade button
	buttons[1] = Button {
		rect = rl.Rectangle {
			x = 100 + f32(button_width + spacing),
			y = f32(entity_y_pos + 50),
			width = f32(button_width),
			height = f32(button_height),
		},
		cost = 20 *
		world.storage.upgrades[entity].velocity_upgrades,
		type = .UPGRADESPEED,
	}
	buttons[2] = Button {
		rect = rl.Rectangle {
			x = 200 + f32(button_width + spacing),
			y = f32(entity_y_pos + 50),
			width = f32(button_width),
			height = f32(button_height),
		},
		cost = 20 *
		world.storage.upgrades[entity].points_upgrades,
		type = .UPGRADEPOINTS,
	}

	world.storage.buttons[entity] = buttons
}

render_buttons_system :: proc(world: ^World) {

	for entity in world.storage.entities {
		for button in world.storage.buttons[entity] {

			//rl.DrawRectangleRec(button.rect, color)

			text := ""
			switch button.type {
			case .UNLOCK:
				{
					text = "unlock"
				}
			case .UPGRADEPOINTS:
				{

					text = "upgrade points"
				}
			case .UPGRADESPEED:
				{

					text = "upgrade speed"
				}

			}

			if button.cost > world.global_points {
			}
			if rl.GuiButton(button.rect, strings.clone_to_cstring(text)) {

			}

			text_width := rl.MeasureText(strings.clone_to_cstring(text), 20)
			text_x := i32(button.rect.x + (button.rect.width - f32(text_width)) / 2)
			text_y := i32(button.rect.y + (button.rect.height - 20) / 2)
			// rl.DrawText(strings.clone_to_cstring(text), text_x, text_y, 10, rl.BLACK)
		}


	}


}


render_system :: proc(world: ^World) {
	for entity in world.storage.entities {
		_, ok := world.storage.unlocked[entity]
		color := ok ? rl.WHITE : rl.BLACK

		// draw buttons under each entity 

		if world.storage.animation_states[entity].state == .IDLE {
			// Get current animation state
			anim_state := world.storage.animation_states[entity]

			// Update the timer
			anim_state.frame_timer += 1

			if anim_state.frame_timer >= world.storage.animation_states[entity].animation_speed {
				// Reset timer and update frame
				anim_state.frame_timer = 0.0
				if anim_state.current_frame >= 7 {
					anim_state.current_frame = 0
				} else {

					anim_state.current_frame += 1
				}

			}


			frame_width := world.storage.sprites[entity].idle_texture.width / 7
			view_rect := rl.Rectangle {
				x      = f32(anim_state.current_frame * frame_width),
				y      = 0,
				height = f32(world.storage.sprites[entity].idle_texture.height),
				width  = f32(frame_width),
			}

			dest := rl.Rectangle {
				x      = f32(world.storage.positions[entity].x),
				y      = f32(world.storage.positions[entity].y),
				height = f32(world.storage.sprites[entity].idle_texture.height),
				width  = f32(frame_width),
			}

			rl.DrawTexturePro(
				world.storage.sprites[entity].idle_texture,
				view_rect,
				dest,
				rl.Vector2{0, 0},
				0,
				color,
			)

			world.storage.animation_states[entity] = anim_state
		}
		if world.storage.animation_states[entity].state == .MOVERIGHT {

			anim_state := world.storage.animation_states[entity]

			// Update the timer
			anim_state.frame_timer += 1

			if anim_state.frame_timer >= world.storage.animation_states[entity].animation_speed {
				// Reset timer and update frame
				anim_state.frame_timer = 0.0
				if anim_state.current_frame >= 13 {
					anim_state.current_frame = 0
				} else {

					anim_state.current_frame += 1
				}

			}


			frame_width := world.storage.sprites[entity].move_right_texture.width / 13
			view_rect := rl.Rectangle {
				x      = f32(anim_state.current_frame * frame_width),
				y      = 0,
				height = f32(world.storage.sprites[entity].move_right_texture.height),
				width  = f32(frame_width),
			}

			dest := rl.Rectangle {
				x      = f32(world.storage.positions[entity].x),
				y      = f32(world.storage.positions[entity].y),
				height = f32(world.storage.sprites[entity].move_right_texture.height),
				width  = f32(frame_width),
			}

			rl.DrawTexturePro(
				world.storage.sprites[entity].move_right_texture,
				view_rect,
				dest,
				rl.Vector2{0, 0},
				0,
				rl.WHITE,
			)

			world.storage.animation_states[entity] = anim_state


		}

		if world.storage.animation_states[entity].state == .MOVELEFT {

			anim_state := world.storage.animation_states[entity]

			// Update the timer
			anim_state.frame_timer += 1

			if anim_state.frame_timer >= world.storage.animation_states[entity].animation_speed {
				// Reset timer and update frame
				anim_state.frame_timer = 0.0
				if anim_state.current_frame >= 13 {
					anim_state.current_frame = 0
				} else {

					anim_state.current_frame += 1
				}

			}


			frame_width := world.storage.sprites[entity].move_right_texture.width / 13
			view_rect := rl.Rectangle {
				x      = f32(anim_state.current_frame * frame_width),
				y      = 0,
				height = f32(world.storage.sprites[entity].move_right_texture.height),
				width  = -f32(frame_width),
			}

			dest := rl.Rectangle {
				x      = f32(world.storage.positions[entity].x),
				y      = f32(world.storage.positions[entity].y),
				height = f32(world.storage.sprites[entity].move_right_texture.height),
				width  = f32(frame_width),
			}

			rl.DrawTexturePro(
				world.storage.sprites[entity].move_right_texture,
				view_rect,
				dest,
				rl.Vector2{0, 0},
				0,
				rl.WHITE,
			)

			world.storage.animation_states[entity] = anim_state


		}
	}

}


movement_system :: proc(world: ^World, entity: Entity) {
	dt := rl.GetFrameTime()
	current_pos := rl.Vector2 {
		f32(world.storage.positions[entity].x),
		f32(world.storage.positions[entity].y),
	}

	is_returning := world.storage.positions[entity].is_returning
	has_collected_point := world.storage.positions[entity].has_collected_point
	velocity: f32

	if !is_returning {
		// Moving right towards 500
		if current_pos.x >= 500.0 {
			// Reached rightmost point, start returning
			is_returning = true
			has_collected_point = true
			velocity = -2.0
		} else {
			velocity = 2.0
		}
	} else {
		// Moving left towards 100
		if current_pos.x <= 100.0 {
			if has_collected_point {
				world.global_points += world.storage.points_contributers[entity].amount
			}
			is_returning = false
			has_collected_point = false
			velocity = 2.0
		} else {
			velocity = -2.0
		}
	}

	// Update position
	new_pos := Position {
		x                   = i32(current_pos.x + velocity),
		y                   = i32(current_pos.y),
		is_returning        = is_returning,
		has_collected_point = has_collected_point,
	}

	anim_state := world.storage.animation_states[entity]
	anim_state.state = velocity > 0 ? .MOVERIGHT : .MOVELEFT

	// Update the world state
	world.storage.positions[entity] = new_pos
	world.storage.animation_states[entity] = anim_state
}
