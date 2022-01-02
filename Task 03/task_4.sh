#!/bin/bash


all_numbers=()
guessed_numbers=()
regex='^[0-9]+$'
plus="+"
step=1
while true; do
    random_number=$((40 + $RANDOM % 10))
    echo Step: $step
    read -p "Please enter the number from 40 to 49 (q - quit): " number
    if [[ $number == "q" ]]; then
        echo "Game over"; exit 1
    elif ! [[ $number =~ $regex ]] || (($number < 40)) || (($number > 49)); then
        echo "Incorrect input!"
        printf "\n"
        continue
    fi
    if (( $number == $random_number )); then
        number_with_plus="$random_number${plus}"
        guessed_numbers[step-1]=$number_with_plus
        all_numbers[step-1]=$number_with_plus
        echo Right! You guessed my number
    else
        all_numbers[step-1]=$random_number
        echo Miss! My number: $random_number
    fi
    hit=$(( 100/${#all_numbers[*]}*${#guessed_numbers[*]} ))
    miss=$(( 100-hit ))
    echo Hit: $hit%, Miss $miss%
    if (( ${#all_numbers[*]} <= 7 )); then
        echo Numbers: ${all_numbers[*]}
    else
        echo Numbers: ${all_numbers[-7]} ${all_numbers[-6]} ${all_numbers[-5]} ${all_numbers[-4]} ${all_numbers[-3]} ${all_numbers[-2]} ${all_numbers[-1]}
    fi
    printf "\n"
    step=$((step+1))
done
