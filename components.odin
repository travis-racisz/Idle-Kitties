package main

import rl "vendor:raylib"

Entity :: distinct u16

Upgrade :: struct {
	velocity_upgrades: i32,
	points_upgrades:   i32,
}

World :: struct {
	next_entity_id: Entity,
	storage:        World_Storage,
	global_points:  i32,
}

PointsContributer :: struct {
	amount:    i32,
	is_active: bool,
}

World_Storage :: struct {
	entities:            [dynamic]Entity,
	velocities:          map[Entity]Velocity,
	positions:           map[Entity]Position,
	sprites:             map[Entity]Sprite,
	animation_states:    map[Entity]AnimationState,
	unlocked:            map[Entity]Unlocked,
	points_contributers: map[Entity]PointsContributer,
	buttons:             map[Entity][]Button,
	upgrades:            map[Entity]Upgrade,
}

Button :: struct {
	rect: rl.Rectangle,
	cost: i32,
	type: enum {
		UNLOCK,
		UPGRADESPEED,
		UPGRADEPOINTS,
	},
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
	x, y:                i32,
	is_returning:        bool,
	has_collected_point: bool,
}

Unlocked :: bool

Sprite :: struct {
	idle_texture:       rl.Texture,
	move_right_texture: rl.Texture,
}
