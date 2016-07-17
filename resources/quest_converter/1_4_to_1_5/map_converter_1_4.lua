-- Solarus 1.4 to 1.5.
-- Changes in the map syntax:
-- - New mandatory properties min_layer and max_layer.
-- - The rank property of enemies no longer exists.
-- - The width and height of custom entities are now mandatory
--   (it was a bug that they were not).

local converter = {}

function converter.convert(quest_path, map_id, default_font_id)

  local input_file_name = quest_path .. "/data/maps/" .. map_id .. ".dat"
  local input_file, error_message = io.open(input_file_name, "rb")
  if input_file == nil then
    error("Cannot open old map file for reading: " .. error_message)
  end

  local text = input_file:read("*a")  -- Read the whole file.

  -- Add the min_layer and max_layer properties.
  if not text:match("[\r\n]+  min_layer = ") then
    text = text:gsub(
        "[\r\n]+  tileset = \"",
        "\n  min_layer = 0,\n  max_layer = 2,\n  tileset = \""
    )
  end

  -- Remove the rank property of enemies.
  text = text:gsub(
      "[\r\n]+  rank = [0-2],",
      ""
  )

  -- Add width and height to custom entities that do not have them.
  text = text:gsub(
      "([\r\n]+custom_entity{[\r\n]+  layer = [-0-9]+,[\r\n]+  x = [-0-9]+,[\r\n]+  y = [-0-9]+,)[\r\n]+  direction = ",
      "%1\n  width = 16,\n  height = 16,\n  direction = "
  )
  text = text:gsub(
      "([\r\n]+custom_entity{[\r\n]+  name = \"[^\"[\r\n]+]*\",[\r\n]+  layer = [-0-9]+,[\r\n]+  x = [-0-9]+,[\r\n]+  y = [-0-9]+,)[\r\n]+  direction = ",
      "%1\n  width = 16,\n  height = 16,\n  direction = "
  )
  text = text:gsub(
      "([\r\n]+custom_entity{[\r\n]+  layer = [-0-9]+,[\r\n]+  x = [-0-9]+,[\r\n]+  y = [-0-9]+,[\r\n]+  width = [0-9]+,)[\r\n]+  direction = ",
      "%1\n  height = 16,\n  direction = "
  )
  text = text:gsub(
      "([\r\n]+custom_entity{[\r\n]+  name = \"[^\"[\r\n]+]*\",[\r\n]+  layer = [-0-9]+,[\r\n]+  x = [-0-9]+,[\r\n]+  y = [-0-9]+,[\r\n]+  width = [0-9]+,)[\r\n]+  direction = ",
      "%1\n  height = 16,\n  direction = "
  )
  text = text:gsub(
      "([\r\n]+custom_entity{[\r\n]+  layer = [-0-9]+,[\r\n]+  x = [-0-9]+,[\r\n]+  y = [-0-9]+,[\r\n]+  height = [0-9]+,)[\r\n]+  direction = ",
      "%1\n  width = 16,\n  direction = "
  )
  text = text:gsub(
      "([\r\n]+custom_entity{[\r\n]+  name = \"[^\"[\r\n]+]*\",[\r\n]+  layer = [-0-9]+,[\r\n]+  x = [-0-9]+,[\r\n]+  y = [-0-9]+,[\r\n]+  height = [0-9]+,)[\r\n]+  direction = ",
      "%1\n  width = 16,\n  direction = "
  )

  input_file:close()

  local output_file_name = input_file_name
  local output_file, error_message = io.open(output_file_name, "w")
  if output_file == nil then
    error("Cannot open new map file for writing: " .. error_message)
  end

  output_file:write(text)
  output_file:close()
end

return converter

