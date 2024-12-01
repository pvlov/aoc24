use std::collections::HashMap;

const INPUT: &str = include_str!("../../inputs/01.txt");

fn parse_input(input: &str) -> (Vec<u32>, Vec<u32>) {
    let (mut left, mut right): (Vec<_>, Vec<_>) = input
        .lines()
        .map(|line| line.split_whitespace())
        .map(|mut split| (split.next().unwrap(), split.next().unwrap()))
        .map(|(l, r)| (l.parse::<u32>().unwrap(), r.parse::<u32>().unwrap()))
        .unzip();

    left.sort();
    right.sort();

    (left, right)
}

fn solve1(input: &str) {
    let (left, right) = parse_input(input);

    let sum = left
        .iter()
        .zip(right.iter())
        .map(|(l, r)| (l.abs_diff(*r)))
        .sum::<u32>();

    println!("Part 1: {}", sum);
}

fn solve2(input: &str) {
    let (left, right) = parse_input(input);

    let mut occurences = HashMap::new();

    for value in right {
        if let Some(count) = occurences.get(&value) {
            occurences.insert(value, count + 1);
        } else {
            occurences.insert(value, 1);
        }
    }

    let sum = left
        .iter()
        .map(|v| v * occurences.get(&v).unwrap_or(&0))
        .sum::<u32>();

    println!("Part 2: {}", sum);
}

fn main() {
    solve1(INPUT);
    solve2(INPUT);
}
