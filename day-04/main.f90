module constants
    integer, parameter :: MAX_LINES = 140
    integer, parameter :: MAX_CHARS = 140
end module constants


program main 
    use constants
    implicit none
    character(len=MAX_CHARS), dimension(MAX_LINES) :: lines
    character(len=256) :: file_name
    integer :: count

    file_name = '04.txt'
    count = 0

    call read_lines(file_name, lines)

    call part_one(lines)
    call part_two(lines)

end program main 

subroutine part_one(lines)
    use constants
    implicit none
    character(len=MAX_CHARS), dimension(MAX_LINES), intent(in) :: lines
    integer :: count

    count = 0

    call check_rows(lines, count, "XMAS")

    call check_rows(lines, count, "SAMX")

    call check_columns(lines, count, "XMAS")

    call check_columns(lines, count, "SAMX")

    call check_diagonals(lines, count, "XMAS")

    call check_diagonals(lines, count, "SAMX")

    print *, "Part 1: ", count

end subroutine part_one

subroutine part_two(lines)
    use constants
    implicit none
    character(len=MAX_CHARS), dimension(MAX_LINES), intent(in) :: lines
    integer :: count

    count = 0
    call check_cross(lines, count)

    print *, "Part 2: ", count

end subroutine part_two

subroutine read_lines(file_name, lines)
    use constants
    implicit none
    character(len=*), intent(in) :: file_name
    character(len=MAX_CHARS), dimension(MAX_LINES), intent(out) :: lines
    integer :: unit, i , status
    character(len=MAX_CHARS) :: line

    unit = 10

    open(unit, file=file_name, status='old', action='read', iostat=status)
    if (status /= 0) then 
        print *, "Error opening file: ", file_name
        stop
    end if

    do i = 1, MAX_LINES 
        read(unit, '(A)', iostat=status) line
        if (status /= 0) exit
        lines(i) = line
    end do

    close(unit)

end subroutine read_lines 


subroutine check_rows(lines, count, needle)
    use constants
    implicit none
    character(len=MAX_CHARS), dimension(MAX_LINES), intent(in) :: lines
    character(len=4), intent(in) :: needle
    integer, intent(out) :: count
    integer :: row, col
   
    do row = 1, MAX_LINES 
        do col = 1, MAX_CHARS - 3 

            if (lines(row)(col:col + 3) == needle) then
                count = count + 1
            end if
        end do
    end do

end subroutine check_rows 

subroutine check_columns(lines, count, needle)
    use constants
    implicit none
    character(len=MAX_CHARS), dimension(MAX_LINES), intent(in) :: lines
    character(len=4), intent(in) :: needle
    integer, intent(out) :: count
    integer :: row, col 
    character(len=4) :: column


    do col = 1, MAX_CHARS 
        do row = 1, MAX_LINES - 3
            column = lines(row)(col:col) // lines (row + 1)(col:col) // lines(row + 2)(col:col) // lines(row + 3)(col:col)

            if (column == needle) then
                count = count + 1
            end if
        end do
    end do

end subroutine check_columns

subroutine check_diagonals(lines, count, needle)
    use constants
    implicit none
    character(len=MAX_CHARS), dimension(MAX_LINES), intent(in) :: lines
    character(len=4), intent(in) :: needle
    integer, intent(out) :: count
    integer :: row, col
    character(len=4) :: diagonal

    ! First top left to bottom right

    do row = 1, MAX_LINES - 3
        do col = 1, MAX_CHARS - 3
            diagonal = lines(row)(col:col) // lines(row + 1)(col + 1:col + 1) // &
                       lines(row + 2)(col + 2:col + 2) // lines(row + 3)(col + 3:col + 3)

            if (diagonal == needle) then
                count = count + 1
            end if
        end do
    end do

    ! Then top right to bottom left

    do row = 1, MAX_LINES - 3
        do col = MAX_CHARS, 4, -1

            diagonal = lines(row)(col:col) // lines(row + 1)(col - 1: col - 1) // &
                       lines(row + 2)(col - 2:col - 2) // lines(row + 3)(col - 3:col -3)

            if (diagonal == needle) then
                count = count + 1
            end if
        end do
    end do

end subroutine check_diagonals

subroutine check_cross(lines, count)
    use constants
    implicit none
    character(len=MAX_CHARS), dimension(MAX_LINES), intent(in) :: lines
    integer, intent(out) :: count
    integer :: row, col
    character(len=3) :: left_diagonal, right_diagonal
    logical :: left_match, right_match

    

    do row = 1, MAX_LINES - 2 
        do col = 1, MAX_CHARS -2
            left_match = .FALSE. 
            right_match = .FALSE. 

            left_diagonal = lines(row)(col:col) // lines(row + 1)(col + 1:col + 1) // &
                            lines(row + 2)(col + 2:col + 2)

            right_diagonal = lines(row)(col + 2:col + 2) // lines(row + 1)(col + 1:col + 1) // &
                            lines(row + 2)(col:col)

            left_match = left_diagonal == "MAS" .or. left_diagonal == "SAM"
            right_match = right_diagonal == "MAS" .or. right_diagonal == "SAM"


            if (left_match .and. right_match) then
                count = count + 1
            end if
        end do
    end do

end subroutine check_cross
