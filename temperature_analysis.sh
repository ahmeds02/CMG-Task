#!/bin/bash

# Declare arrays to store temperature and humidity readings
declare -A temperatures
declare -A humidities

# Read input file and store readings in arrays
while read line; do
  if [[ $line == "reference"* ]]; then
    # Parse reference values
    IFS=' ' read -ra ref <<< "$line"
    ref_temp=${ref[1]}
    ref_hum=${ref[2]}
  elif [[ $line == "thermometer"* ]]; then
    # Parse thermometer readings
    IFS=' ' read -ra therm <<< "$line"
    current_therm=${therm[1]}
  elif [[ $line == "humidity"* ]]; then
    # Parse humidity readings
    IFS=' ' read -ra hum <<< "$line"
    current_hum=${hum[1]}
  else
    # Parse time and value for temperature/humidity readings
    IFS=' ' read -ra reading <<< "$line"
    if [[ $current_therm ]]; then
      temperatures["$current_therm"]+="${reading[1]} "
    elif [[ $current_hum ]]; then
      humidities["$current_hum"]+="${reading[1]} "
    fi
  fi
done < "$1"

# Evaluate thermometer readings
for therm in "${!temperatures[@]}"; do
  readings=(${temperatures[$therm]})
  mean=$(echo "scale=2; (${readings[*]})/${#readings[@]}" | bc)
  diff=$(echo "$mean-$ref_temp" | bc)
  stdev=$(echo "scale=2; sqrt(((${readings[*]})/${#readings[@]}) - ($mean)^2)" | bc)
  if (( $(echo "$diff > -0.5" | bc -l) )) && (( $(echo "$diff < 0.5" | bc -l) )) && (( $(echo "$stdev < 3" | bc -l) )); then
    echo "$therm: ultra precise"
  elif (( $(echo "$diff > -0.5" | bc -l) )) && (( $(echo "$diff < 0.5" | bc -l) )) && (( $(echo "$stdev < 5" | bc -l) )); then
    echo "$therm: very precise"
  else
    echo "$therm: precise"
  fi
done

# Evaluate humidity readings
for hum in "${!humidities[@]}"; do
  readings=(${humidities[$hum]})
  discard=false
  for reading in "${readings[@]}"; do
    diff=$(echo "$reading-$ref_hum" | bc)
    if (( $(echo "$diff > -1" | bc -l) )) && (( $(echo "$diff < 1" | bc -l) )); then
      continue
    else
      discard=true
      break
    fi
  done
  if [[ $discard == true ]]; then
    echo "$hum: discard"
  else
    echo "$hum: keep"
  fi
done
