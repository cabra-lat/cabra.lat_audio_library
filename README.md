# Audio Material Library for Godot

![Godot Adventures](https://blog.cabra.lat/assets/2025/01/11/imgs/godot-adventures.png)

**A Godot Engine plugin that introduces an Audio Library system mimicking the AnimatedSprite2D interface but designed specifically for sounds.** This plugin simplifies sound management based on material collision metadata, allowing you to easily assign and manage sound collections for different materials in your 3D projects.

## Features

- **Material-Based Sound Assignment**: Assign different collision sounds based on object materials
- **Intuitive Editor Interface**: Familiar workflow similar to Godot's built-in SpriteFrames panel
- **Easy Sound Management**: Add, remove, and organize sounds without complex dictionary structures
- **Context-Aware Playback**: Play different sounds depending on which part of an object is hit
- **Editor Integration**: Edit sound collections directly in the Godot editor

## Topics
audio • game-development • audio-player • godot • godot-engine • godot-engine-editor • godot-engine-4

## Installation

1. Clone this repository into your Godot project's `addons` directory:
   ```
   git clone https://github.com/cabra-lat/cabra.lat_audio_library.git addons/cabra.lat_audio_library
   ```

2. Enable the plugin in Godot:
   - Go to Project > Project Settings > Plugins
   - Find "Audio Material Library" and click "Activate"

## Mini Tutorial: Using the Audio Material Library (Like AnimatedSprite2D)

This plugin works very similarly to Godot's AnimatedSprite2D node, but for sounds. Here's a step-by-step guide to get you started:

### 1. Setting Up the Resource

1. In the FileSystem dock, right-click and select "New Resource"
2. Choose "AudioMaterialLibrary" from the list
3. Save it with a meaningful name (e.g., `wood_material_sounds.tres`)

### 2. Configuring Sounds (The AnimatedSprite2D Way)

The interface will look familiar if you've used AnimatedSprite2D:

1. **Create Material Groups** (like animation names in SpriteFrames):
   - Click the "+" button to add a new material group
   - Name it after your material (e.g., "Wood", "Metal", "Glass")
   - You can have multiple groups for different contexts (e.g., "Wood_Impact", "Wood_Break")

2. **Add Sounds to Each Group**:
   - Select a material group
   - Click "Add Sound" (similar to adding frames in SpriteFrames)
   - Browse and select your sound file (.wav, .ogg)
   - Repeat to add multiple sounds for variety

3. **Configure Sound Properties**:
   - Adjust volume levels per sound if needed
   - Set pitch variation range for more natural playback
   - Configure minimum delay between plays to prevent spamming

![The Perfect Plugin](https://blog.cabra.lat/assets/2025/01/11/imgs/the-perfect-plugin.png)

### 3. Attaching to Your Objects

1. Select your 3D object with collision shapes
2. In the Inspector, find the CollisionShape3D node
3. Add a new property (or use an existing one) called "audio_material"
4. Assign your AudioMaterialLibrary resource to this property

### 4. Basic Usage Code

```gdscript
# Simple collision handler
func _on_body_entered(body):
    # Get the audio material from the colliding body
    var audio_material = body.get("audio_material")
    
    if audio_material:
        # Play a random sound from the default group
        audio_material.play_random_sound()
```

### 5. Advanced Usage Examples

#### Playing Specific Sound Groups
```gdscript
# When a character hits a wall with different force levels
func _on_hit_wall(force):
    var audio_material = get_audio_material(wall)
    
    if force > 10:
        audio_material.play_random_sound("Wood_Break")  # Play break sounds for hard hits
    else:
        audio_material.play_random_sound("Wood_Impact") # Play impact sounds for light hits
```

#### Context-Aware Sound Selection
```gdscript
# Different sounds based on which part of an object was hit
func _on_body_part_hit(part_name):
    var audio_material = get_audio_material(enemy)
    
    # Play different sound based on which body part was hit
    audio_material.play_random_sound(part_name + "_hit")
    
    # Example: If part_name is "head", it will play sounds from "head_hit" group
```

#### Adding Sounds Programmatically
```gdscript
# Create and configure an audio library at runtime
var audio_lib = AudioMaterialLibrary.new()

# Add a new material group
audio_lib.add_material_group("Metal")

# Add sounds to the group
audio_lib.add_sound_to_group("Metal", preload("metal_clang1.wav"))
audio_lib.add_sound_to_group("Metal", preload("metal_clang2.wav"))
audio_lib.add_sound_to_group("Metal", preload("metal_clang3.wav"))

# Configure playback properties
audio_lib.set_volume_for_group("Metal", 0.8)
audio_lib.set_pitch_range_for_group("Metal", 0.9, 1.1)  # Slight pitch variation

# Assign to object
collision_shape.set("audio_material", audio_lib)
```

### 6. Editor Workflow Tips

- **Naming Convention**: Use consistent naming for your material groups (e.g., "MaterialName_Action")
- **Sound Organization**: Keep similar sounds in the same group for easy management
- **Preview Button**: Click the play button next to each sound to preview it directly in the editor
- **Duplicate Groups**: Right-click a group to duplicate it as a starting point for similar materials

## Why This Plugin?

Before developing this plugin, managing collision sounds required complex dictionary structures that were difficult to maintain. While Resources offered better editor integration, they became cumbersome when dealing with numerous sound collections.

This plugin bridges the gap by providing:
- A visual interface for managing sound collections (mimicking the AnimatedSprite2D workflow)
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
