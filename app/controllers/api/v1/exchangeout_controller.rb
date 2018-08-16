module Api
  module V1
    class ExchangeoutController < ApplicationController
      def index

        treasuryexch = TrStatement.where(:status => 'I')
          .where(:coinbag.not => "")
          .where(:coinbag_dest.not => "")
          .where(:coinbag_dest.not => nil)
          .where(:currency_dest.not => nil)
          .where(:mov_type => 'exch')
          .order(date_time: :desc)
          .map{ |f| {
            :User => User.where(id: f.from).map(&:nickname)*",",
            :Coinbag => Coinbag.where(id: f.coinbag).map(&:coinbag)*",",
            :Currency => Currency.where(id: f.currency).map(&:currency)*",",
            :Amount => f.amount + f.fee,
            :Date => f.date_time,
            :Category => Classification.where(id: f.classification).map(&:classification)*",",
            :detail => f.detail,
            :celebrate => f.celebrate,
            :created_by => User.where(id: f.created_by).map(&:nickname)*","
            }
          }
        render json: {status: 'SUCCESS',  message: 'Loaded exchange', App: 'Veda treasury web app',
          api_version:'v1', table:'Exchange', data:treasuryexch},status: :ok
      end
    end
  end
end
