#!/bin/bash

to_decimal() {
    local input="$1"
    # If input starts with 0x, it's hexadecimal
    if [[ "$input" =~ ^0x ]]; then
        echo "$((input))"  # Convert hex to decimal
    # If input is purely hexadecimal (without 0x), still convert it
    elif [[ "$input" =~ ^[0-9A-Fa-f]+$ ]]; then
        echo "$((16#$input))"  # Convert hex to decimal using base 16
    else
        echo "$input"  # Assume it's already a decimal number
    fi
}

to_hex() {
    printf "0x%X\n" "$1"  # Convert decimal to hex
}

add() {
    echo "$(( $1 + $2 ))"
}

subtract() {
    echo "$(( $1 - $2 ))"
}

multiply() {
    echo "$(( $1 * $2 ))"
}

divide() {
    if [ "$2" -eq 0 ]; then
        echo "Error: Division by zero"
    else
        echo "$(( $1 / $2 ))"
    fi
}

power() {
    base=$1
    exp=$2
    result=1

    if [ "$exp" -lt 0 ]; then
        echo "Error: Negative exponents not supported without 'bc'"
        return
    fi

    for ((i=0; i<exp; i++)); do
        result=$((result * base))
    done

    echo "$result"
}

last_result=0
while true; do
    echo "Last result: $last_result (Hex: $(to_hex $last_result))"
    read -p "Enter first number (or press Enter to use last result): " num1

    # If no input, use last result
    if [ -z "$num1" ]; then
        num1=$last_result
    else
        num1=$(to_decimal "$num1")  # Convert input to decimal if necessary
    fi

    echo "Enter operation (+, -, *, /, ^):"
    read operation

    echo "Enter second number:"
    read num2
    num2=$(to_decimal "$num2")  # Convert second number to decimal if necessary

    case $operation in
        +)
            result=$(add $num1 $num2)
            ;;
        -)
            result=$(subtract $num1 $num2)
            ;;
        \*)
            result=$(multiply $num1 $num2)
            ;;
        /)
            result=$(divide $num1 $num2)
            ;;
        ^)
            result=$(power $num1 $num2)
            ;;
        *)
            echo "Invalid operation. Supported operations are +, -, *, /, ^."
            continue
            ;;
    esac

    echo "Result: $result (Hex: $(to_hex $result))"
    last_result=$result

    read -p "Do you want to perform another calculation? (y/n): " continue_choice
    if [ "$continue_choice" != "y" ]; then
        break
    fi
done


