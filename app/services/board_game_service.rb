class BoardGameService
    def initialize
        @redis = Redis.new(host: "localhost")
    end

    def start(name)
        data = { name: name, player: 1, score: 0 }

        @redis.set("active_game", { boards: [
            [nil, nil, nil], 
            [nil, nil, nil], 
            [nil, nil, nil]
        ], winner: nil }.to_json )

        @redis.set("turn_now", { player: 1 }.to_json);

        data
    end

    def clear_board
        @redis.set("active_game", nil)
        @redis.set("turn_now", nil)
    end

    def turn_now
        data = @redis.get("turn_now");

        JSON.parse(data)
    end

    def step(x, y)
        board = @redis.get("active_game")
        parse_data =  JSON.parse(board)
        parse_board = parse_data["boards"]

        if parse_data["winner"]
            return parse_data
        end

        select_step = parse_board[x][y]
        result = { boards: parse_board, winner: nil }
        if !select_step
            parse_board[x][y] = 'X'
            @redis.set("turn_now", { player: 2 }.to_json);
            player_1_winner = player_1_win(parse_board)
            if player_1_winner
                result[:winner] = player_1_winner
            end

            if (!result[:winner])
                parse_board = auto_player_2_step(x, y, parse_board)
                player_2_winner = player_2_win(parse_board)
                if player_2_winner
                    result[:winner] = player_2_winner
                end
            end

            @redis.set("active_game", result.to_json )
        end

        result
    end

    private
        def auto_player_2_step(x, y, parse_board)
            free_step = []
            parse_board.each_with_index do |x, x_idx|
                x.each_with_index do |y, y_idx|
                    if !y
                        free_step.push([x_idx, y_idx])
                    end
                end
            end
            
            player_2_step = free_step.sample

            parse_board[player_2_step[0]][player_2_step[1]] = 'O'

            @redis.set("turn_now", { player: 1 }.to_json);

            parse_board
        end

        def player_1_win(parse_board)
            return 1 if player_win(parse_board, 'X')
        end

        def player_2_win(parse_board)
            return 2 if player_win(parse_board, 'O')
        end

        def player_win(parse_board, player_sign)
            if ( parse_board[0] || parse_board[1] || parse_board[2] ) == [player_sign, player_sign, player_sign] || 
                ( parse_board[0][0] == player_sign && parse_board[1][0] == player_sign && parse_board[2][0] == player_sign ) ||
                ( parse_board[1][0] == player_sign && parse_board[1][1] == player_sign && parse_board[2][1] == player_sign ) ||
                ( parse_board[2][0] == player_sign && parse_board[2][1] == player_sign && parse_board[2][2] == player_sign ) ||
                ( parse_board[0][0] == player_sign && parse_board[1][1] == player_sign && parse_board[2][2] == player_sign ) ||
                ( parse_board[2][0] == player_sign && parse_board[1][1] == player_sign && parse_board[0][2] == player_sign )
                return true
            end

            false
        end
end