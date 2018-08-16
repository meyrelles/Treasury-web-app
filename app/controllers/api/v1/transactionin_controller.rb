module Api
  module V1
    class TransactioninController < ApplicationController
      def index
        if params[:currency]
          treasuryin = TrStatement.where(:status => 'I')
            .where(:coinbag_dest.not => "")
            .where(:mov_type => 'tr')
            .where(:to.not => User.where(username: 'world').map(&:id)*",")
            .where(:currency => Currency.where(currency: params[:currency]).map(&:id)*",")
            .order(date_time: :desc)
            .map{ |f| {
              :Amount => f.amount,
              :Currency => Currency.where(id: f.currency).map(&:currency)*",",
              :Coinbag => Coinbag.where(id: f.coinbag_dest).map(&:coinbag)*",",
              :From => User.where(id: f.from).map(&:nickname)*",",
              :To => User.where(id: f.to).map(&:nickname)*",",
              :Date => f.date_time,
              :Category => Classification.where(id: f.classification).map(&:classification)*",",
              :detail => f.detail,
              :celebrate => f.celebrate,
              :created_by => User.where(id: f.created_by).map(&:nickname)*",",
              }
            }
          render json: {status: 'SUCCESS', Currency:params[:currency], message: 'Loaded transactions in', App: 'Veda treasury web app',
            api_version:'v1', table:'Transactions IN', data:treasuryin},status: :ok
        else
          treasuryin = TrStatement.where(:status => 'I')
            .where(:coinbag_dest.not => "")
            .where(:mov_type => 'tr')
            .where(:to.not => User.where(username: 'world').map(&:id)*",")
            .order(date_time: :asc)
            .map{ |f| {
              :Amount => f.amount,
              :Currency => Currency.where(id: f.currency).map(&:currency)*",",
              :Coinbag => Coinbag.where(id: f.coinbag_dest).map(&:coinbag)*",",
              :From => User.where(id: f.from).map(&:nickname)*",",
              :To => User.where(id: f.to).map(&:nickname)*",",
              :Date => f.date_time,
              :Category => Classification.where(id: f.classification).map(&:classification)*",",
              :detail => f.detail,
              :celebrate => f.celebrate,
              :created_by => User.where(id: f.created_by).map(&:nickname)*",",
              }
            }
          render json: {status: 'SUCCESS',  message: 'Loaded transactions in', App: 'Veda treasury web app',
            api_version:'v1', table:'Transactions IN', data:treasuryin},status: :ok
        end
      end

      def show

      end
    end
  end
end
