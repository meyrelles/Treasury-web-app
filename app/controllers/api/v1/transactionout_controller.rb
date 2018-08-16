module Api
  module V1
    class TransactionoutController < ApplicationController
      def index
        treasuryout = TrStatement.where(:status => 'I')
          .where(:coinbag.not => "")
          .where(:mov_type => 'tr')
          .where(:from.not => User.where(username: 'world').map(&:id)*",")
          .order(date_time: :desc)
          .map{ |f| {
            :Amount => f.amount + f.fee,
            :Currency => Currency.where(id: f.currency).map(&:currency)*",",
            :Coinbag => Coinbag.where(id: f.coinbag).map(&:coinbag)*",",
            :From => User.where(id: f.from).map(&:nickname)*",",
            :To => User.where(id: f.to).map(&:nickname)*",",
            :Date => f.date_time,
            :Category => Classification.where(id: f.classification).map(&:classification)*",",
            :detail => f.detail,
            :celebrate => f.celebrate,
            :created_by => User.where(id: f.created_by).map(&:nickname)*","
            }
          }
        render json: {status: 'SUCCESS',  message: 'Loaded transactions out', App: 'Veda treasury web app',
          api_version:'v1', table:'Transactions OUT', data:treasuryout},status: :ok
      end
    end
  end
end
