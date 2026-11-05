#!/bin/bash
HWMON_PATH="/sys/class/hwmon/hwmon7"

package=$(cat "$HWMON_PATH/temp1_input")
package_c=$((package / 1000))

lines=()
for f in "$HWMON_PATH"/temp*_input; do
    base=$(basename "$f" _input)
    [ "$base" = "temp1" ] && continue
    label=$(cat "$HWMON_PATH/${base}_label" 2>/dev/null || echo "$base")
    val=$(cat "$f")
    val_c=$((val / 1000))
    core_num=${label##* }
    lines+=("$core_num|${label}: ${val_c}°C")
done

IFS=$'\n' sorted=($(sort -t '|' -k1 -n <<<"${lines[*]}"))
unset IFS

tooltip=$(printf '%s\n' "${sorted[@]#*|}" | head -c -1)

jq -nc --arg temp "${package_c}°C" --arg tooltip "$tooltip" \
  '{text: ("  " + $temp), tooltip: $tooltip}'
