local current_selection = nil
local changing_wind_direction = false
local highlight = true
guiEnabled = false
snowToggle = false
local snow = {}
-- default settings
settings = {type = "real", density = 250, wind_direction = {0.01,0.01}, wind_speed = 1, snowflake_min_size = 1, snowflake_max_size = 3, fall_speed_min = 1, fall_speed_max = 4, jitter = true}
