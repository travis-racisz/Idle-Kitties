package main
import "core:fmt"


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

render_system :: proc(world: ^World) {
	frame_time := rl.GetFrameTime()
	for entity in world.storage.entities {
		if world.storage.animation_states[entity].state == .IDLE {
			// Get current animation state
			anim_state := world.storage.animation_states[entity]

			// Update the timer
			anim_state.frame_timer += frame_time

			animation_speed := 0.1
			if f64(anim_state.frame_timer) >= animation_speed {
				// Reset timer and update frame
				anim_state.frame_timer = 0
				if anim_state.current_frame >= 7 {
					anim_state.current_frame = 1
				} else {
					anim_state.current_frame += 1
				}

				// Write back the modified state to the map
				world.storage.animation_states[entity] = anim_state
			}

			frame_width := world.storage.sprites[entity].texture.width / 8
			view_rect := rl.Rectangle {
				x      = f32(frame_width * (anim_state.current_frame)),
				y      = 0,
				height = f32(world.storage.sprites[entity].texture.height),
				width  = f32(frame_width),
			}

			dest := rl.Rectangle {
				x      = f32(world.storage.positions[entity].x),
				y      = f32(world.storage.positions[entity].y),
				height = f32(world.storage.sprites[entity].texture.height),
				width  = f32(frame_width),
			}

			rl.DrawTexturePro(
				world.storage.sprites[entity].texture,
				view_rect,
				dest,
				rl.Vector2{0, 0},
				0,
				rl.WHITE,
			)
		}
	}
}
