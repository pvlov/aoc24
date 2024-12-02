# frozen_string_literal: true

def solve1(reports)
  safe_reports = reports.select { |report| safe?(report) }

  puts "Part 1: #{safe_reports.length}"
end

def solve2(reports)
  safe_reports = reports.select { |report| safe?(report) || safe_with_dampener?(report) }

  puts "Part 2: #{safe_reports.length}"
end

def ascending?(report)
  report.sort == report
end

def descending?(report)
  report.sort.reverse == report
end

def safe?(report)
  (ascending?(report) || descending?(report)) && report.each_cons(2).all? { |a, b| (a - b).abs.between?(1, 3) }
end

def safe_with_dampener?(report)
  (0...report.length).each do |i|
    new_report = report.dup
    new_report.delete_at(i)
    return true if safe?(new_report)
  end
  false
end

def main
  reports = []

  File.foreach('../../inputs/02.txt') do |line|
    reports << line.split.map(&:to_i)
  end

  solve1(reports)
  solve2(reports)
end

main
