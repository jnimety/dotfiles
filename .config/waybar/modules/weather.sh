#!/usr/bin/env bash

cachedir=~/.cache/waybar
cachefile=${0##*/}-$1
cachepath=$cachedir/"$cachefile"
lc_measurement='metric'

if [ ! -d $cachedir ]; then
  mkdir -p $cachedir
fi

if [ ! -f "$cachepath" ]; then
  touch "$cachepath"
fi

cacheage=$(($(date +%s) - $(date -r "$cachepath" +%s)))
if [ $cacheage -gt 1740 ] || [ ! -s "$cachepath" ]; then
  curl -s https://en.wttr.in/"$1"\?format=j1 >"$cachepath" 2>&1
fi

# see https://wttr.in/:bash.function for inspiration
for _token in $(locale LC_MEASUREMENT); do
  case $_token in
  1) lc_measurement='metric' ;;
  2) lc_measurement='imperial' ;;
  esac
done 2>/dev/null

case $lc_measurement in
'metric')
  temperature=$(jq -r '.current_condition[0].temp_C' "$cachepath")
  temperature_unit="°C"
  ;;
'imperial')
  temperature=$(jq -r '.current_condition[0].temp_F' "$cachepath")
  temperature_unit="°F"
  ;;
esac

areaname=$(jq -r '.nearest_area[0].areaName[0].value' "$cachepath")

# https://github.com/chubin/wttr.in/blob/master/lib/constants.py
# https://www.worldweatheronline.com/weather-api/api/docs/weather-icons.aspx
weathercode=$(jq -r '.current_condition[0].weatherCode' "$cachepath")

# https://www.nerdfonts.com/cheat-sheet
case $weathercode in
113)
  icon=""
  class="Sunny"
  ;;
116)
  icon=""
  class="PartlyCloudy"
  ;;
119)
  icon=""
  class="Cloudy"
  ;;
122)
  icon="󰖐"
  class="VeryCloudy"
  ;;
143 | 248 | 260)
  icon=""
  class="Fog"
  ;;
176 | 263 | 353)
  icon=""
  class="LightShowers"
  ;;
266 | 293 | 296)
  icon=""
  class="LightRain"
  ;;
299 | 305 | 356)
  icon="󰖖"
  class="HeavyShowers"
  ;;
302 | 308 | 359)
  icon=""
  class="HeavyRain"
  ;;
200 | 386)
  icon=""
  class="ThunderyShowers"
  ;;
389)
  icon=""
  class="ThunderyHeavyRain"
  ;;
182 | 185 | 281 | 284 | 311 | 314 | 317 | 350 | 377)
  icon=""
  class="LightSleet"
  ;;
179 | 362 | 365 | 374)
  icon=""
  class="LightSleetShowers"
  ;;
227 | 320)
  icon="󰼴"
  class="LightSnow"
  ;;
323 | 326 | 368)
  icon="󰼴"
  class="LightSnowShowers"
  ;;
230 | 329 | 332 | 338)
  icon="󰼶"
  class="HeavySnow"
  ;;
335 | 371 | 395)
  icon="󰼶"
  class="HeavySnowShowers"
  ;;
392)
  icon=""
  class="ThunderySnowShowers"
  ;;
*)
  icon=""
  class="error"
  ;;
esac

printf '{"text":"%d%s  %s", "alt":"%s", "tooltip":"%s: %d%s %s", "class":"%s"}' "$temperature" "$temperature_unit" "$icon" "$areaname" "$areaname" "$temperature" "$temperature_unit" "$class" "$class"
