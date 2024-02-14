class BoardGamesController < ApplicationController
    protect_from_forgery with: :null_session

    def initialize
        @board_game_service = BoardGameService.new
    end

    def index  
        @board_game_service.clear_board
    end

    def start
        data = @board_game_service.start(start_params[:name])

        render json: { data: data, message: 'success', success: true }, status: :created
    end

    def step
        data = @board_game_service.step(step_params[:x], step_params[:y])

        render json: { data: data, message: 'success', success: true }, status: :created
    end

    def turn_now
        data = @board_game_service.turn_now()

        render json: { data: data, message: 'success', success: true }, status: :ok
    end

    private
        def start_params
            params.require(:board_games).permit(:name)
        end

        def step_params
            params.require(:board_games).permit(:x, :y)
        end
end
