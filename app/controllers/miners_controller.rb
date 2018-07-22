class MinersController < ApplicationController

  #GET
  def index
    #@hash = Hash[@hash.sort_by{|k, v| v}]
    #.pluck(:hashrate, :id).map(&:hashrate).to_a
  end

  def my_action
    render :layout => false
    #render json: Task.group(:goal_id).group_by_day(:completed_at).count.chart_json
  end



  private



end
