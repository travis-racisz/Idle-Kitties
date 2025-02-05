package main

import Clay "clay/bindings/odin/clay-odin"
import "core:fmt"
import "core:math"
import "core:strings"
import "vendor:raylib"


RaylibFont :: struct {
	fontId: u16,
	font:   raylib.Font,
}


ClayColorToRaylibColor :: proc(color: Clay.Color) -> raylib.Color {
	return raylib.Color{u8(color.r), u8(color.g), u8(color.b), u8(color.a)}

}


measure_text :: proc "c" (
	text: Clay.StringSlice,
	config: ^Clay.TextElementConfig,
	user_data: uintptr,
) -> Clay.Dimensions {
	// get the text height and width for whichever font we are using 
	textSize := Clay.Dimensions{0, 0}

	maxTextWidth: f32 = 0
	lineTextWidth: f32 = 0

	textHeight := f32(config.fontSize)
	font := raylib.GetFontDefault()

	for i in 0 ..< int(text.length) {
		if text.chars[i] == '\n' {
			maxTextWidth = max(maxTextWidth, lineTextWidth)
			lineTextWidth = 0
			continue

		}
		index := i32(text.chars[i]) - 32
		if (font.glyphs[index].advanceX != 0) {
			lineTextWidth += f32(font.glyphs[index].advanceX)

		} else {
			lineTextWidth += (font.recs[index].width + f32(font.glyphs[index].offsetX))


		}
	}

	maxTextWidth = max(maxTextWidth, lineTextWidth)

	textSize.width = maxTextWidth / 2
	textSize.height = textHeight


	return textSize


}

clay_raylib_renderer :: proc(
	render_commands: ^Clay.ClayArray(Clay.RenderCommand),
	allocator := context.temp_allocator,
) {
	// loop through all of the render_commands
	for i in 0 ..< render_commands.length {
		render_command := Clay.RenderCommandArray_Get(render_commands, i)
		bounding_box := render_command.boundingBox

		// switch case to tell it how to render each command, such as Button or whatnot 
		switch (render_command.commandType) {
		case Clay.RenderCommandType.None:
			{}


		case Clay.RenderCommandType.Image:
			{

				config := render_command.renderData.image
				// TODO image handling
				imageTexture := cast(^raylib.Texture2D)config.imageData
				raylib.DrawTextureEx(
					imageTexture^,
					raylib.Vector2{bounding_box.x, bounding_box.y},
					0,
					bounding_box.width / cast(f32)imageTexture.width,
					ClayColorToRaylibColor(config.backgroundColor),
				)

			}

		case Clay.RenderCommandType.ScissorEnd:
			{

				raylib.EndScissorMode()
			}

		case Clay.RenderCommandType.ScissorStart:
			raylib.BeginScissorMode(
				cast(i32)math.round(bounding_box.x),
				cast(i32)math.round(bounding_box.y),
				cast(i32)math.round(bounding_box.width),
				cast(i32)math.round(bounding_box.height),
			)
		case Clay.RenderCommandType.Border:
			config := render_command.renderData.border
			// Left border
			if (config.width.left > 0) {
				raylib.DrawRectangle(
					cast(i32)math.round(bounding_box.x),
					cast(i32)math.round(bounding_box.y + config.cornerRadius.topLeft),
					cast(i32)config.width.left,
					cast(i32)math.round(
						bounding_box.height -
						config.cornerRadius.topLeft -
						config.cornerRadius.bottomLeft,
					),
					ClayColorToRaylibColor(config.color),
				)
			}
			// Right border
			if (config.width.right > 0) {
				raylib.DrawRectangle(
					cast(i32)math.round(
						bounding_box.x + bounding_box.width - cast(f32)config.width.right,
					),
					cast(i32)math.round(bounding_box.y + config.cornerRadius.topRight),
					cast(i32)config.width.right,
					cast(i32)math.round(
						bounding_box.height -
						config.cornerRadius.topRight -
						config.cornerRadius.bottomRight,
					),
					ClayColorToRaylibColor(config.color),
				)
			}
			// Top border
			if (config.width.top > 0) {
				raylib.DrawRectangle(
					cast(i32)math.round(bounding_box.x + config.cornerRadius.topLeft),
					cast(i32)math.round(bounding_box.y),
					cast(i32)math.round(
						bounding_box.width -
						config.cornerRadius.topLeft -
						config.cornerRadius.topRight,
					),
					cast(i32)config.width.top,
					ClayColorToRaylibColor(config.color),
				)
			}
			// Bottom border
			if (config.width.bottom > 0) {
				raylib.DrawRectangle(
					cast(i32)math.round(bounding_box.x + config.cornerRadius.bottomLeft),
					cast(i32)math.round(
						bounding_box.y + bounding_box.height - cast(f32)config.width.bottom,
					),
					cast(i32)math.round(
						bounding_box.width -
						config.cornerRadius.bottomLeft -
						config.cornerRadius.bottomRight,
					),
					cast(i32)config.width.bottom,
					ClayColorToRaylibColor(config.color),
				)
			}
			if (config.cornerRadius.topLeft > 0) {
				raylib.DrawRing(
					raylib.Vector2 {
						math.round(bounding_box.x + config.cornerRadius.topLeft),
						math.round(bounding_box.y + config.cornerRadius.topLeft),
					},
					math.round(config.cornerRadius.topLeft - cast(f32)config.width.top),
					config.cornerRadius.topLeft,
					180,
					270,
					10,
					ClayColorToRaylibColor(config.color),
				)
			}
			if (config.cornerRadius.topRight > 0) {
				raylib.DrawRing(
					raylib.Vector2 {
						math.round(
							bounding_box.x + bounding_box.width - config.cornerRadius.topRight,
						),
						math.round(bounding_box.y + config.cornerRadius.topRight),
					},
					math.round(config.cornerRadius.topRight - cast(f32)config.width.top),
					config.cornerRadius.topRight,
					270,
					360,
					10,
					ClayColorToRaylibColor(config.color),
				)
			}
			if (config.cornerRadius.bottomLeft > 0) {
				raylib.DrawRing(
					raylib.Vector2 {
						math.round(bounding_box.x + config.cornerRadius.bottomLeft),
						math.round(
							bounding_box.y + bounding_box.height - config.cornerRadius.bottomLeft,
						),
					},
					math.round(config.cornerRadius.bottomLeft - cast(f32)config.width.top),
					config.cornerRadius.bottomLeft,
					90,
					180,
					10,
					ClayColorToRaylibColor(config.color),
				)
			}
			if (config.cornerRadius.bottomRight > 0) {
				raylib.DrawRing(
					raylib.Vector2 {
						math.round(
							bounding_box.x + bounding_box.width - config.cornerRadius.bottomRight,
						),
						math.round(
							bounding_box.y + bounding_box.height - config.cornerRadius.bottomRight,
						),
					},
					math.round(config.cornerRadius.bottomRight - cast(f32)config.width.bottom),
					config.cornerRadius.bottomRight,
					0.1,
					90,
					10,
					ClayColorToRaylibColor(config.color),
				)
			}

		case Clay.RenderCommandType.Rectangle:
			{
				config := render_command.renderData.rectangle

				rect := raylib.Rectangle {
					x      = bounding_box.x,
					y      = bounding_box.y,
					height = bounding_box.height,
					width  = bounding_box.width,
				}
				if config.cornerRadius.topLeft > 0 {
					// render with raylib.DrawRectangleRounded()
					radius: f32 =
						(config.cornerRadius.topLeft * 2) /
						min(bounding_box.width, bounding_box.height)

					raylib.DrawRectangleRounded(
						rect,
						radius,
						8,
						ClayColorToRaylibColor(config.backgroundColor),
					)

				} else {
					// render just a regular rectangle
					raylib.DrawRectangleRec(rect, ClayColorToRaylibColor(config.backgroundColor))

				}


			}

		case Clay.RenderCommandType.Text:
			{
				config := render_command.renderData.text
				// Raylib uses standard C strings so isn't compatible with cheap slices, we need to clone the string to append null terminator
				text := string(config.stringContents.chars[:config.stringContents.length])
				cloned := strings.clone_to_cstring(text, allocator)

				raylib.DrawTextEx(
					raylib.GetFontDefault(),
					cloned,
					raylib.Vector2{bounding_box.x, bounding_box.y},
					f32(config.fontSize),
					f32(config.letterSpacing),
					ClayColorToRaylibColor(config.textColor),
				)


			}

		case Clay.RenderCommandType.Custom:
			{}
		}


	}


}

error_handler :: proc "c" (error_data: Clay.ErrorData) {
	context = context
	fmt.print(error_data, "Error!")
}


initialize_clay :: proc() {
	minMemorySize := Clay.MinMemorySize()
	memory := make([^]u8, minMemorySize)
	arena: Clay.Arena = Clay.CreateArenaWithCapacityAndMemory(minMemorySize, memory)
	Clay.Initialize(
		arena,
		{f32(raylib.GetScreenWidth()), f32(raylib.GetScreenHeight())},
		{handler = error_handler},
	)

	Clay.SetMeasureTextFunction(measure_text, 0)

}
