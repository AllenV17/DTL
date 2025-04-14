#!/bin/bash

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

last_result=0
while true; do
    echo "Last result: $last_result"
    read -p "Enter first number (or press Enter to use last result): " num1

    if [ -z "$num1" ]; then
        num1=$last_result
    fi

    echo "Enter operation (+, -, *, /):"
    read operation

    echo "Enter second number:"
    read num2

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
        *)
            echo "Invalid operation. Supported operations are +, -, *, /."
            continue
            ;;
    esac

    echo "Result: $result"
    last_result=$result

    read -p "Do you want to perform another calculation? (y/n): " continue_choice
    if [ "$continue_choice" != "y" ]; then
        break
    fi
done

