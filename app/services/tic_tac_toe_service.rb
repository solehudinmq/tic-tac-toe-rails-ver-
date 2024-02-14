PLAYER_ONE = 0
PLAYER_TWO = 1

class TicTacToeService
    def make_move(board, row, col, turn)
        print (turn == PLAYER_ONE) ? "First player's turn: " : "Second player's turn: "
        while(1)
            move = gets.chomp.upcase.chars.sort
            begin
                if board[row.index(move[0])][col.index(move[1])] == nil # Valid move
                    board[row.index(move[0])][col.index(move[1])] = (turn == PLAYER_ONE ? "X" : "O")
                    return
                end
                print "Spot taken. Try again: "
            rescue
                print "Invalid move. Try again: "
            end
        end
    end
    
    def draw_board(board, row, col)
        puts "\n  " + col.join(" ")
        row.each_with_index do |key, index|
            puts key + " " + board[index].map{ |val| make_blanks(val, index) }.join("|")
        end
        puts "\n"
    end
    
    def make_blanks(val, index)
        return " " if val == nil && index == 2
        return "_" if val == nil
        return val
    end
    
    def game_won?(board, turn)
        row_win = board
        col_win = board.transpose
        dia_win = [[board[0][0],board[1][1],board[2][2]],[board[0][2],board[1][1],board[2][0]]]
        wins = row_win + col_win + dia_win

        wins.each { |try| return true if (try.uniq.length == 1 && try[0] != nil) }
        return false
    end
    
    def play()
        row_index = ["A","B","C"]
        col_index = ["D","E","F"]
        board = Array.new(3){ Array.new(3) }
        turn = PLAYER_ONE

        puts "\nLet's Play Tic-Tac-Toe\n"
        draw_board(board, row_index, col_index)

        9.times do
            make_move(board, row_index, col_index, turn)
            draw_board(board, row_index, col_index)
            if(game_won?(board, turn))
            puts "Congratulations. Player " + (turn == PLAYER_ONE ? "one" : "two") + " won!"
            return
            end
            turn = (turn + 1) % 2
        end

        puts "It's a tie!"
    end
end