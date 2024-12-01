use std::collections::HashMap;

const INPUT: &str = include_str!("../../inputs/01.txt");

fn parse_input(input: &str) -> (Vec<u32>, Vec<u32>) {
    let mut left = Vec::new();
    let mut right = Vec::new();

    for line in input.lines() {
        let mut split = line.split_whitespace();
        let l = split.next().unwrap().parse::<u32>().unwrap();
        let r = split.next().unwrap().parse::<u32>().unwrap();

        left.push(l);
        right.push(r);
    }

    left.sort_unstable();
    right.sort_unstable();

    (left, right)
}

fn solve1(input: &str) {
    let (left, right) = parse_input(input);

    let sum = left
        .iter()
        .zip(&right)
        .map(|(l, r)| (l.abs_diff(*r)))
        .sum::<u32>();

    println!("Part 1: {}", sum);
}

fn solve2(input: &str) {
    let (left, right) = parse_input(input);

    let mut occurences = HashMap::new();

    for value in right {
        *occurences.entry(value).or_insert(0) += 1;
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
