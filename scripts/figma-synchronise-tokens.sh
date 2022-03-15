#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: one parameter is missing, you should pass an url that contains JSON tokens as parameter: ./figma-synchronisetokens.sh [URL]"
    exit 1
fi

# Raw JSON file containing all design tokens passed as first parameter of script
URL=$1

# Global is an alternative object that contains general values applied in any chosen theme
GLOBAL="global"

# This file provides missing tokens from design teams that are necessary for the library
TOKENS_EXTENSION="scripts/tokensExtension.json"

# We declarer all theme from where to generate tokens
declare -a themes=("light" "dark")

# This function will get JSON, parse it with jq and create all necessary tokens
function generateTokens {
  THEME=$1
  JSON=$(curl "${URL}")

  # Gives all shades and their colors in hexadecimal values
  PARSED_SHADES=$(echo "${JSON}" | jq --sort-keys --arg theme "${THEME}" '
  reduce (.[$theme].shades | to_entries | .[]) as $sentiment
    ({}; . + {"\($sentiment.key)": (
      reduce($sentiment.value | to_entries | .[]) as $shade
        ({}; . + { "\($shade.key)": ($shade.value.value | ascii_downcase) })) })
  ')
  # Match tokens and shades colors
  GENERATED_TOKENS_COLOR=$(echo "${JSON} $( cat "${TOKENS_EXTENSION}")" | jq -s '.[0] * .[1]' | jq --sort-keys --arg global "${GLOBAL}" --argjson shades "${PARSED_SHADES}" '
  .[$global] | with_entries(select(.value | has("backgroundStrong"))) |
    reduce (. | to_entries | .[]) as $sentiment
      ({}; . + {"\($sentiment.key)": (reduce($sentiment.value | to_entries | .[]) as $token
        ({}; . + { "\($token.key)": ($token.value.value | gsub("[$]"; ".") | split(".") as $number | $shades[$number[2]][$number[3]]) })) }) |
          {"colors": .}
  ')
  # Overload of tokens colors specific to each theme, depending
  GENERATED_OVERLOADED_COLORS=$(echo "${JSON} $( cat "${TOKENS_EXTENSION}")" | jq -s '.[0] * .[1]' | jq --sort-keys --arg theme "${THEME}" --argjson shades "${PARSED_SHADES}" '
  .[$theme] | with_entries(select(.value | has("backgroundWeakElevated"))) |
    reduce (. | to_entries | .[]) as $sentiment
      ({}; . + {"\($sentiment.key)": (reduce($sentiment.value | to_entries | .[]) as $token
        ({}; . + { "\($token.key)": ($token.value.value | gsub("[$]"; ".") | split(".") as $number | $shades[$number[2]][$number[3]]) })) }) |
          {"colors": .}
  ')

  # Gives all colors of shadows
  SHADOWS_COLOR=$(echo "${JSON}" | jq --sort-keys --arg theme "${THEME}" '
    reduce (.[$theme].shadows | to_entries | .[]) as $sentiment
      ({}; . + {"\($sentiment.key)": (reduce($sentiment.value | to_entries | .[]) as $shade
        ({}; . + { "\($shade.key)": $shade.value.value })) })
  ')
  # Match all shadows properties including color in one line
  GENERATED_SHADOW_TOKENS=$(echo "${JSON}" | jq --sort-keys --arg global "${GLOBAL}" --argjson shadows_color "${SHADOWS_COLOR}" '
  .[$global] | with_entries(select(.value.type == "boxShadow")) |
    reduce (. | to_entries | .[]) as $sentiment
      ({}; . + {"\($sentiment.key)": "\($sentiment.value.value.x) \($sentiment.value.value.y) \($sentiment.value.value.blur) \($sentiment.value.value.spread) \($sentiment.value.value.color | gsub("[$]shadows."; "") |
          split(".") as $number |
            $shadows_color[$number[0]][$number[1]])"}) |
              {"shadows": .}
  ')

  # There are others colors for overlay for example
  GENERATED_OTHERS_TOKENS=$(echo "${JSON}" | jq --sort-keys --arg theme "${THEME}" '
    reduce (.[$theme].others | to_entries | .[]) as $sentiment
      ({}; . + {"\($sentiment.key)": $sentiment.value.value}) | {"colors": .}
  ')

  FINAL_RESULT=$(echo "${GENERATED_TOKENS_COLOR}" "${GENERATED_OVERLOADED_COLORS}" "${GENERATED_SHADOW_TOKENS}" "${GENERATED_OTHERS_TOKENS}" | jq --slurp --sort-keys '.[0] * .[1] * .[2] * .[3]')
}

# Generate theme tokens and create file into "src/theme/tokens"
for i in "${themes[@]}"
do
   echo "Generating theme: $i"
   generateTokens "$i"

   # Generate colors tokens
   (printf "/**
 * Provides all tokens of a specific theme edited by design team.
 * This file is automatically generated from /scripts/figma-synchronise-tokens.sh.
 * PLEASE DO NOT EDIT HERE
 */
 /* eslint-disable sort-keys */
export default "; echo "${FINAL_RESULT}"; echo "/* eslint-enable sort-keys */") > src/theme/tokens/"${i}".ts
done
