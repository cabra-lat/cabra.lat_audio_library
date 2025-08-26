# Audio Material Library for Godot

![Godot Adventures](https://blog.cabra.lat/assets/2025/01/11/imgs/godot-adventures.png)

**A Godot Engine plugin that introduces an Audio Library system mimicking the SpriteFrames interface but designed specifically for sounds.** This plugin simplifies sound management based on material collision metadata, allowing you to easily assign and manage sound collections for different materials in your projects.

## Features

- **Material-Based Sound Assignment**: Assign different collision sounds based on object materials
- **Intuitive Editor Interface**: Familiar workflow similar to Godot's built-in SpriteFrames panel
- **Easy Sound Management**: Organize sounds in collections without complex dictionary structures
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

## Mini Tutorial: Using the Audio Library (Like SpriteFrames)

This plugin works very similarly to Godot's SpriteFrames system (used with AnimatedSprite2D), but for sounds. Here's a step-by-step guide to get you started:

### 1. Understanding the Core Concept

As explained in the [blog post](https://blog.cabra.lat/godot-adventures.html), the creator was frustrated with managing sound collections using dictionaries or unwieldy resource lists. The solution was to create an interface similar to SpriteFrames:

> "I needed something similar but designed for sounds... an interface similar to the `SpriteFrames` panel, which appears when you use the `AnimatedSprite2D` node. With SpriteFrames, you can add animation names and frames for each animation and then play them with a simple call like `animation.play('animation-name')`."

### 2. Setting Up the Resource

1. In the FileSystem dock, right-click and select "New Resource"
2. Choose "AudioLibrary" from the list (this is the core class of the plugin)
3. Save it with a meaningful name (e.g., `wood_material_sounds.tres`)

### 3. Configuring Sound Collections

The interface will look familiar if you've used SpriteFrames:

1. **Create Collections** (like animation names in SpriteFrames):
   - Click the "+" button to add a new collection
   - Name it after your material or action (e.g., "Wood", "Metal_Impact", "Glass_Break")
   - The system automatically handles naming conflicts (like "Wood_2", "Wood_3")

2. **Add Sounds to Collections**:
   - Select a collection
   - Click "Add Sound" (similar to adding frames in SpriteFrames)
   - Browse and select your sound file (.wav, .ogg)
   - Repeat to add multiple sounds for variety

![The Perfect Plugin](https://blog.cabra.lat/assets/2025/01/11/imgs/the-perfect-plugin.png)

### 4. Basic Usage Code

```gdscript
# Create or load an AudioLibrary resource
var audio_lib = preload("res://path/to/wood_sounds.tres")

# Add sounds programmatically (if needed)
if not audio_lib.has_collection("Impact"):
    audio_lib.create_collection("Impact")
audio_lib.add_sound("Impact", preload("res://sounds/wood_hit1.wav"))
audio_lib.add_sound("Impact", preload("res://sounds/wood_hit2.wav"))
audio_lib.add_sound("Impact", preload("res://sounds/wood_hit3.wav"))

# Play a random sound from a collection
func play_impact_sound():
    if audio_lib.has_collection("Impact"):
        var sounds = audio_lib.get_sounds("Impact")
        if sounds.size() > 0:
            var random_index = randi() % sounds.size()
            $AudioPlayer.stream = sounds[random_index]
            $AudioPlayer.play()
```

### 5. Advanced Usage Examples

#### Simple Collision Sound System
```gdscript
# In your collision handling code
func _on_body_entered(body):
    # Get the audio library from the colliding body
    var audio_lib = body.get("audio_library")
    
    if audio_lib:
        # Play a random sound from the "Impact" collection
        play_sound_from_collection(audio_lib, "Impact")

# Helper function to play sounds from a collection
func play_sound_from_collection(audio_lib: AudioLibrary, collection: String):
    var sounds = audio_lib.get_sounds(collection)
    if sounds.size() > 0:
        var random_index = randi() % sounds.size()
        $AudioPlayer.stream = sounds[random_index]
        $AudioPlayer.play()
```

#### Material-Based Sound System (As Described in the Blog)
```gdscript
# Set up on your physics objects
func _ready():
    # Assign the audio library to the collision object
    $CollisionShape3D.set("audio_library", preload("res://materials/wood_sounds.tres"))

# In your physics world (e.g., a separate physics processing script)
func handle_collision(collider, collided_with):
    # Get the audio library from the collided object
    var audio_lib = collided_with.get("audio_library")
    
    if audio_lib:
        # Determine appropriate sound collection based on collision
        var collection = "Impact"
        if collider.velocity.length() > 10:
            collection = "HardImpact"
            
        play_sound_from_collection(audio_lib, collection)
```

#### Dynamic Sound Collection Management
```gdscript
# Create collections dynamically
func setup_character_sounds():
    var char_sounds = AudioLibrary.new()
    
    # Create collections with automatic unique naming
    char_sounds.create_collection("Footstep")
    char_sounds.create_collection("Jump")
    char_sounds.create_collection("Land")
    
    # Add multiple sounds at once
    var footsteps = [
        preload("res://sounds/footstep1.wav"),
        preload("res://sounds/footstep2.wav"),
        preload("res://sounds/footstep3.wav")
    ]
    char_sounds.add_sounds("Footstep", footsteps)
    
    # Rename collections safely
    char_sounds.rename_collection("Footstep", "Character_Footstep")
    
    # Save for later use
    ResourceSaver.save(char_sounds, "res://player_sounds.tres")
```

### 6. Editor Workflow Tips

- **Collections are like animations**: Think of collections as "sound animations" - each collection contains multiple sound variations
- **Naming conventions**: Use descriptive names like "Material_Action" (e.g., "Wood_Impact", "Metal_Slide")
- **Sound variety**: Add 3-5 sounds per collection for natural variation
- **Preview sounds**: Click the play button next to each sound to preview it directly in the editor
- **Resource organization**: Store your AudioLibrary resources in a dedicated folder (e.g., `res://audio/materials/`)

## Why This Plugin?

As detailed in the [Godot Adventures blog post](https://blog.cabra.lat/godot-adventures.html), this plugin solves a real problem:

> "Initially, I used a `Dictionary` to map materials to an `Array` of sounds and then played the appropriate sound. While it worked, the system was difficult to maintain and adding new sounds was cumbersome. To address this, I switched to using a `Resource`, which essentially wraps the `Dictionary` and allows for easier editing within the Godot editor. However, this approach introduced its own challenge: scrolling through an overwhelming number of resources to find the one I wanted to add."

This plugin bridges the gap by providing:
- A visual interface for managing sound collections (mimicking the SpriteFrames workflow)
- Streamlined workflow for adding and editing sound collections
- Easy integration with physics-based interactions

## Development Status

While functional, the plugin is still in active development. Some UI elements may appear unusual and minor bugs might exist, but the core functionality works reliably.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Credits

Created by Cabra, as documented in the [Godot Adventures blog post](https://blog.cabra.lat/godot-adventures.html)

---

*This plugin is designed for Godot 4.X and provides a more intuitive way to manage sound collections compared to manual dictionary management.*