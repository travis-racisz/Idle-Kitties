package main

import rl "vendor:raylib"

Entity :: distinct u16


World :: struct {
	next_entity_id: Entity,
	storage:        World_Storage,
}

World_Storage :: struct {
	entities:         [dynamic]Entity,
	velocities:       map[Entity]Velocity,
	positions:        map[Entity]Position,
	sprites:          map[Entity]Sprite,
	animation_states: map[Entity]AnimationState,
}


AnimationState :: struct {
	state:           enum {
		IDLE,
		MOVERIGHT,
		MOVELEFT,
	},
	current_frame:   i32,
	animation_speed: f32,
	frame_timer:     f32,
}

Velocity :: struct {
	x, y: i32,
}

Position :: struct {
	x, y: i32,
}

Sprite :: struct {
	texture: rl.Texture,
}
