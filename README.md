# Idle Kitties!

A delightful idle game featuring a collection of animated cats, each contributing to your point total in their own unique way.

## Features

- Multiple unique cat characters with distinct animations
- Idle point generation system
- Particle effect background with smooth gradient
- Interactive upgrade system
- Save/load game functionality
- Adjustable music volume with multiple tracks
- Scrollable game world
- Title screen with falling cats animation

## Prerequisites

To build and run this game from source, you'll need to install odin:
- [Odin Compiler](https://odin-lang.org/)


## Installation from source

1. Clone the repository:
```bash
git clone https://github.com/travis-racisz/Idle-Kitties
cd idle-kitties
```

2. Build the project:
```bash
odin build . -file main.odin
```

1. Run the game:
```bash
./idle-kitties
```

## Windows install
Download from the releases tab, unzip the folder and the exe is included 

## Game Controls

- **Mouse Wheel**: Scroll up/down to navigate the game world
- **Left Click**: Interact with cats and buttons
- **ESC**: Access options menu

## Gameplay

- Start with one unlocked cat that generates points
- Use accumulated points to unlock more cats
- Each cat has unique point generation rates
- Upgrade cats to increase their point generation
- Save your progress to continue later

## Project Structure

```
idle-kitties/
├── assets/
│   ├── AllCatsDemo/     # Cat sprite assets
│   ├── music/           # Background music tracks
├── main.odin            # Main game loop and initialization
├── savegame.odin        # Save/load functionality
|── systems.odin         # Hold the systems to render/move cats and gain points
|── components.odin      # Sets up components for cats to inherit 
└── README.md            # This file
```

## Asset Credits

- Cat sprites: [https://toffeecraft.itch.io/cat-pixel-mega-pack]
- Music: [https://pixabay.com/music/]
- Sound effects: [I made the one sound effect with Audacity]

## Acknowledgments

- Built with [Odin Programming Language](https://odin-lang.org/)
- Rendered using [Raylib](https://www.raylib.com/)
