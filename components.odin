package main

import rl "vendor:raylib"

Entity :: distinct u16


World :: struct {
	next_entity_id: Entity,
	storage:        World_Storage,
}

World_Storage :: struct {
	velocities: map[Entity]Velocity,
	positions:  map[Entity]Position,
	sprites:    map[Entity]Sprite,
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
