class BirdsController < ApplicationController
  def index
    @birds = Bird.all
    render plain: "Hello #{@birds[3].name}"
  end
end
