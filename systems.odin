package main


import rl "vendor:raylib"


add_velocity :: proc(world: ^World, entity: Entity, velocity: Velocity) {
	world.storage.velocities[entity] = velocity

}


add_position :: proc(world: ^World, entity: Entity, position: Position) {
	world.storage.positions[entity] = position

}

create_entity :: proc(world: ^World, entity: Entity) -> Entity {
	world.next_entity_id = entity
	world.next_entity_id += 1
	return entity
}

create_world :: proc() -> World {
	return World {
		next_entity_id = 0,
		storage = {velocities = make(map[Entity]Velocity), positions = make(map[Entity]Position)},
	}


}

add_sprite :: proc(world: ^World, entity: Entity, sprite: Sprite) {
	world.storage.sprites[entity] = sprite

}
