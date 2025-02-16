package main

import "core:math/rand"
import rl "vendor:raylib"

PARTICLE_COUNT :: 150

Particle :: struct {
	position: rl.Vector2,
	velocity: rl.Vector2,
	color:    rl.Color,
	size:     f32,
	alpha:    f32,
}

Background :: struct {
	particles:       [PARTICLE_COUNT]Particle,
	gradient_top:    rl.Color,
	gradient_bottom: rl.Color,
}

background: Background

init_background :: proc() {
	// Initialize with a nice color gradient
	background.gradient_top = rl.Color{147, 211, 255, 255} // Light blue
	background.gradient_bottom = rl.Color{241, 195, 255, 255} // Light purple

	// Initialize particles with random positions and properties
	for &particle in &background.particles {
		reset_particle(&particle, true)
	}
}

reset_particle :: proc(particle: ^Particle, randomize_y: bool) {
	particle.position = {
		f32(rand.int31_max(i32(rl.GetScreenWidth()))),
		f32(randomize_y ? rand.int31_max(i32(rl.GetScreenHeight())) : 0),
	}

	// Random upward velocity with some horizontal drift
	particle.velocity = {rand.float32_range(-0.5, 0.5), rand.float32_range(-0.5, 2.0)}

	// Random size and transparency
	particle.size = rand.float32_range(2, 6)
	particle.alpha = rand.float32_range(0.1, 0.7)

	// Slightly randomized white color for a magical effect
	white_variation := rand.int31_max(30)
	particle.color = rl.Color {
		225 + u8(white_variation),
		225 + u8(white_variation),
		255,
		u8(particle.alpha * 255),
	}
}

update_background :: proc() {
	screen_height := f32(rl.GetScreenHeight())

	for &particle in &background.particles {
		// Update position based on velocity
		particle.position += particle.velocity

		// Fade out as particles move up
		particle.alpha -= 0.001
		particle.color.a = u8(max(0, particle.alpha * 255))

		// Reset particles that move off screen or fade out
		if particle.position.y < -10 || particle.alpha <= 0 {
			reset_particle(&particle, false)
		}
	}
}

render_background :: proc() {
	// Draw gradient background
	rl.DrawRectangleGradientV(
		0,
		0,
		rl.GetScreenWidth(),
		rl.GetScreenHeight(),
		background.gradient_top,
		background.gradient_bottom,
	)

	// Draw particles
	for particle in background.particles {
		rl.DrawCircleV(particle.position, particle.size, particle.color)
	}
}
