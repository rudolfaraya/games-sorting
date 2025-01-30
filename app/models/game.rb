class Game < ApplicationRecord
  belongs_to :genre
  belongs_to :platform
end
