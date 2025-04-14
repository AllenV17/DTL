#!/bin/bash

sum=0
count=0

echo "Enter integers one by one. Press Enter on a blank line to finish."

# Loop to read numbers
while true; do
    read -p "Enter a number: " number

    # Stop if input is empty
    if [ -z "$number" ]; then
        break
    fi

    # Check for valid integer using regex
    if [[ "$number" =~ ^-?[0-9]+$ ]]; then
        sum=$((sum + number))         # Add number to sum
        count=$((count + 1))          # Increment count
    else
        echo "Invalid input. Please enter a valid integer."
    fi
done

# Calculate and display result
if [ $count -gt 0 ]; then
    average=$((sum / count))          # Integer division
    echo "Sum: $sum"
    echo "Average (integer only): $average"
else
    echo "No numbers were entered."
fi

