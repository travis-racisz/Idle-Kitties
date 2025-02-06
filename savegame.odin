package main

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

Save_Storage_JSON :: struct {
	entities:            [dynamic]Entity, // Entity becomes u16 for JSON
	velocities:          map[u16]Velocity,
	positions:           map[u16]Position,
	unlocked:            map[u16]Unlocked,
	points_contributers: map[u16]PointsContributer,
	upgrades:            map[u16]Upgrade,
	animation_states:    map[u16]AnimationState,
}

SaveData_JSON :: struct {
	next_entity_id: u16, // Entity becomes u16 for JSON
	global_points:  i32,
	storage:        Save_Storage_JSON,
}

// Convert World_Storage to JSON-friendly structure
storage_to_json :: proc(storage: World_Storage) -> Save_Storage_JSON {
	json_storage := Save_Storage_JSON {
		entities            = storage.entities,
		velocities          = make(map[u16]Velocity),
		positions           = make(map[u16]Position),
		unlocked            = make(map[u16]Unlocked),
		points_contributers = make(map[u16]PointsContributer),
		upgrades            = make(map[u16]Upgrade),
		animation_states    = make(map[u16]AnimationState),
	}

	// Convert Entity keys to u16
	for key, value in storage.velocities {
		json_storage.velocities[u16(key)] = value
	}
	for key, value in storage.positions {
		json_storage.positions[u16(key)] = value
	}
	for key, value in storage.unlocked {
		json_storage.unlocked[u16(key)] = value
	}
	for key, value in storage.points_contributers {
		json_storage.points_contributers[u16(key)] = value
	}
	for key, value in storage.upgrades {
		json_storage.upgrades[u16(key)] = value
	}
	for key, value in storage.animation_states {
		json_storage.animation_states[u16(key)] = value
	}

	return json_storage
}

// Convert JSON structure back to World_Storage
json_to_storage :: proc(json_storage: Save_Storage_JSON) -> World_Storage {
	storage := World_Storage {
		entities            = json_storage.entities,
		velocities          = make(map[Entity]Velocity),
		positions           = make(map[Entity]Position),
		unlocked            = make(map[Entity]Unlocked),
		points_contributers = make(map[Entity]PointsContributer),
		upgrades            = make(map[Entity]Upgrade),
		animation_states    = make(map[Entity]AnimationState),
		sprites             = make(map[Entity]Sprite),
		buttons             = make(map[Entity][]Button),
	}

	// Convert u16 keys back to Entity
	for key, value in json_storage.velocities {
		storage.velocities[Entity(key)] = value
	}
	for key, value in json_storage.positions {
		storage.positions[Entity(key)] = value
	}
	for key, value in json_storage.unlocked {
		storage.unlocked[Entity(key)] = value
	}
	for key, value in json_storage.points_contributers {
		storage.points_contributers[Entity(key)] = value
	}
	for key, value in json_storage.upgrades {
		storage.upgrades[Entity(key)] = value
	}
	for key, value in json_storage.animation_states {
		storage.animation_states[Entity(key)] = value
	}

	return storage
}

// Update your save/load functions:
create_save_game :: proc(world: ^World) {
	// Convert to JSON-friendly structure
	save_data := SaveData_JSON {
		next_entity_id = u16(world.next_entity_id),
		global_points  = world.global_points,
		storage        = storage_to_json(world.storage),
	}

	if data, err := json.marshal(save_data); err == nil {
		os.write_entire_file("save_game.json", data)
	} else {
		fmt.eprintln(err)
	}
}

load_save_game :: proc() -> bool {
	if data, ok := os.read_entire_file("./save_game.json"); ok {
		save_data: SaveData_JSON
		if err := json.unmarshal(data, &save_data); err != nil {
			fmt.eprintln("Unmarshal error:", err)
			return false
		}

		// Restore world state
		world.next_entity_id = Entity(save_data.next_entity_id)
		world.global_points = save_data.global_points
		world.storage = json_to_storage(save_data.storage)

		// Reload textures for each entity
		for entity in world.storage.entities {
			sprite := Sprite {
				idle_texture       = rl.LoadTexture(
					strings.clone_to_cstring(idle_textures[entity]),
				),
				move_right_texture = rl.LoadTexture(
					strings.clone_to_cstring(jumping_textures[entity]),
				),
			}
			world.storage.sprites[entity] = sprite

			// Recreate buttons
			add_buttons(&world, entity, world.storage.positions[entity].y, (i32(entity) * 100))
		}

		return true
	}
	return false
}
