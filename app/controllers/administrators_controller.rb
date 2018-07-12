class AdministratorsController < ApplicationController

  #GET
  def index

  end


  #POST
  def exec
    begin
      $reql_input = params[:administrators][:"reql_cmd"]
      $reql_output = NoBrainer.run(:profile => true) { |r| eval(params[:administrators][:"reql_cmd"]) }
      redirect_to administrators_path
    rescue StandardError => e
      print e
      flash[:alert] = "The query return a error, please try again."
      redirect_to administrators_path
    end
  end
end
