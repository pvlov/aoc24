<?php

function part1($content) {
    $pattern = '/mul\((\d{1,3})(,)(\s*\d{1,3}){0,2}\)/';
    $sum = 0;

    preg_match_all( $pattern, $content, $matches);

    foreach ( $matches[0] as $key => $match ) {
        $first_number = $matches[1][$key];
        $second_number = $matches[3][$key];

        $sum += $first_number * $second_number;
    }

    print "Part 1: $sum  ";
} 

function part2($content) {

    $full_pattern = '/mul\((\d{1,3})(,)(\s*\d{1,3})(,)?(\s*\d{1,3})?\)|do\(\)|don\'t\(\)/';
    $only_mul_pattern = '/mul\((\d{1,3})(,)(\s*\d{1,3})(,)?(\s*\d{1,3})?\)/';
    $only_do_pattern = '/do\(\)/';
    $only_dont_pattern = '/don\'t\(\)/';
    $enabled = true;
    $sum = 0;

    preg_match_all( $full_pattern, $content, $matches);

    foreach ($matches[0] as $key => $match) {
        if (preg_match($only_mul_pattern, $match) && $enabled) {
            $first_number = $matches[1][$key];
            $second_number = $matches[3][$key];

            $sum += $first_number * $second_number;
        }
        // Check if it's "do()"
        elseif (preg_match($only_do_pattern, $match)) {
            $enabled = true;
        }
        // Check if it's "don't()"
        elseif (preg_match($only_dont_pattern, $match)) {
            $enabled = false;
        }
    }

    print "Part 2: $sum";
}

$content = file_get_contents('../03.txt');
part1($content);
part2($content);

?>