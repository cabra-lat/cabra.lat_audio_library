# Godot Audio Material Library

![Godot Adventures](https://blog.cabra.lat/assets/2025/01/11/imgs/godot-adventures.png)

A Godot Engine plugin that simplifies sound management based on material collision metadata. Inspired by SpriteFrames panel, this plugin allows you to easily assign and manage sound collections for different materials in your 3D projects.

## Features

- **Material-Based Sound Assignment**: Assign different collision sounds based on object materials
- **Intuitive Editor Interface**: Similar to Godot's built-in SpriteFrames panel
- **Easy Sound Management**: Add, remove, and organize sounds without complex dictionary structures
- **Context-Aware Playback**: Play different sounds depending on which part of an object is hit
- **Editor Integration**: Edit sound collections directly in the Godot editor

## Installation

1. Clone this repository into your Godot project's `addons` directory:
   ```
   git clone https://github.com/cabra-lat/cabra.lat_audio_library.git addons/cabra.lat_audio_library
   ```

2. Enable the plugin in Godot:
   - Go to Project > Project Settings > Plugins
   - Find "Audio Material Library" and click "Activate"

## Usage

1. Create a new `AudioMaterialLibrary` resource
2. Assign it to your objects' collision shapes
3. Configure sound collections for different materials in the intuitive editor panel

![The Perfect Plugin](https://blog.cabra.lat/assets/2025/01/11/imgs/the-perfect-plugin.png)

```gdscript
# Example usage in your collision handling code
func _on_body_entered(body):
    var audio_material = get_audio_material(body)
    if audio_material:
        audio_material.play_random_sound()
```

## Why This Plugin?

Before developing this plugin, managing collision sounds required complex dictionary structures that were difficult to maintain. While Resources offered better editor integration, they became cumbersome when dealing with numerous sound collections.

This plugin bridges the gap by providing:
- A visual interface for managing sound collections
- Streamlined workflow similar to Godot's built-in animation system
- Easy integration with physics-based interactions

## Development Status

While functional, the plugin is still in active development. Some UI elements may appear unusual and minor bugs might exist, but the core functionality works reliably.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Credits

Created by Cabra, as documented in the [Godot Adventures blog post](https://blog.cabra.lat/godot-adventures.html)

---

*This plugin is designed for Godot 4.X and leverages the improved State Machine features mentioned in the blog post.*
