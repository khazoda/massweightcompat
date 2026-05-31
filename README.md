## Create Aeronautics: Sable Mass Mod Compatibility

This datapack adds Sable physics properties for blocks from other mods.

Properties use priority `1100` so they reliably override Sable's defaults. The files under `data/massweightcompat/physics_block_properties/` mirror Sable's property values and relevant state overrides. This keeps behavior consistent when the datapack is distributed as a mod too.

Block lists are grouped by property and mod under:
`data/massweightcompat/tags/block/properties/`

if you have any questions you can ask me them on [Discord](https://discord.com/invite/vEZUkSxwR9) :)

## Build

Run `.\build.ps1 -Version "1.0.1+1.21.1"` to create `massweightcompat-1.0.1+1.21.1.zip` and `massweightcompat-1.0.1+1.21.1.jar` under `export/`.
