class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]

  # GET /games or /games.json
  def index
    session["filters"] ||= {}
    session["filters"].merge!(filters_params)

    @games = Game.includes(:genre, :platform)
                  .then { search_by_title _1 }
                  .then { filter_by_genre _1 }
                  .then { filter_by_platform _1 }
                  .then { apply_order _1 }
  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy!

    respond_to do |format|
      format.html { redirect_to games_path, status: :see_other, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:title, :genre_id, :platform_id)
    end

    def filters_params
      params.permit(:title, :genre_id, :platform_id, :column, :direction)
    end

    def search_by_title(scope)
      session['filters']['title'].present? ? scope.where('games.title like ?', "%#{session['filters']['title']}%") : scope
    end

    def filter_by_genre(scope)
      session['filters']['genre_id'].present? ? scope.where(genre_id: session['filters']['genre_id']) : scope
    end

    def filter_by_platform(scope)
      session['filters']['platform_id'].present? ? scope.where(platform_id: session['filters']['platform_id']) : scope
    end

    def apply_order(scope)
      scope.order(session['filters'].slice('column', 'direction').values.join(' '))
    end
end
