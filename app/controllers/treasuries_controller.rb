class TreasuriesController < ApplicationController
  require 'will_paginate'
  require 'will_paginate/array'
  require 'will_paginate/active_record'


  #GET
  def index
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end
    if cookies[:default_member].present?
      @default_member = cookies[:default_member]
    else
      @default_member = session[:user_id]
    end
    tresuryBalance
    tresuryCoinbagBalance
    tresuryCategoryBalance
  end


  #POST
  def filters
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end
    if params[:Update_table]
      cookies[:default_member] = params[:transaction][:member]
      redirect_to treasuries_path
    else
      updateRatesCryptorates
      updateFiatRates
      redirect_to treasuries_path
    end
  end

  private
    def updateFiatRates
      @currencies = Currency.where(cur_type: 'fiat')

      @currencies.each do |currencies|
        if currencies.exch_symbol != ''
          @url = "http://free.currencyconverterapi.com/api/v5/convert?q=#{currencies.exch_symbol}&compact=y"
          @fiat = HTTParty.get(@url).to_a
          @fiat = HashWithIndifferentAccess.new(@fiat[0][1])

          NoBrainer.run(:profile => true) { |r| r.table("currencies").
            filter(id: "#{currencies.id}").
            update(exch_rate: "#{@fiat[:val].to_f}")
          }

        end

      end

      #@fiat = HTTParty.get('http://free.currencyconverterapi.com/api/v5/convert?q=EUR_USD&compact=y').to_a
      #@fiat = HashWithIndifferentAccess.new(@fiat[0][1])
    end



    def updateRatesCryptorates
        #LOAD Cryptorates from coinmarketcap
        @cryptoNames = HTTParty.get('https://api.coinmarketcap.com/v2/listings/')
        @cryptoNames = JSON.parse(@cryptoNames.body)['data']

        @currencies = Currency.all

        #Update currencies names and rates
        @currencies.each do |currencies|
          if currencies.exch_symbol != '' and currencies.exch_symbol != nil
            currencyName = currencies.exch_symbol
          else
            currencyName = currencies.currency
          end
          @cryptoNames.each do |k|
            if k['symbol'].upcase == currencyName.upcase
              currencyID = k['id']
              @cryptoRate = HTTParty.get("https://api.coinmarketcap.com/v2/ticker/#{currencyID}/")
              @cryptoRate = JSON.parse(@cryptoRate.body)['data']

              #if @cryptoRate['quotes']['USD']['price'] > 0
                rate = @cryptoRate['quotes']['USD']['price'].to_f
                name = @cryptoRate['name']
                symbol = @cryptoRate['symbol']
                NoBrainer.run(:profile => true) { |r| r.table("currencies").
                  filter(id: "#{currencies.id}").
                  update(exch_rate: "#{rate}",
                  exch_name: "#{name}",
                  exch_symbol: "#{symbol}")
                }

              #end
            end
          end
        end
    end





    def tresuryBalance

      @currencies = Currency.all
      @currencies = @currencies.order(:currency)

      @treasuryin = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter({status: 'I'}).
        group{|user| user.pluck(
          'from',
          'currency'
          )}.
        sum{|value| value['amount'] * (-1) - value['fee']}
      }

      @treasuryout = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter({status: 'I'}).
        group{|user| user.pluck(
          'to',
          'currency_dest'
          )}.
        sum{|value| value['amount_dest']}
      }

      @treasury = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter({status: 'I'}).
        group{|user| user.pluck(
          'from',
          'currency'
          )}.
        sum{|value| value['amount'] * (-1) - value['fee']}
      }

      @treasuryin =  @treasuryin.to_a
      @treasuryout =  @treasuryout.to_a
      @treasury =  @treasury.to_a

      @treasury.each do |values|
        values[0] = values[0].to_a
      end

      @treasuryin.each do |values|
        values[0] = values[0].to_a
      end

      @treasuryout.each do |values|
        values[0] = values[0].to_a
      end

      @xa1 = @treasuryin.dup
      @xa2 = @treasuryout.dup
      @xa3 = @treasury.dup

      #Change currency code by currency name
      @treasuryin.each do |cin|
        cin[0][0][1] = Currency.where(id: cin[0][0][1]).map(&:currency)*","
      end
      #Change currency code by currency name
      @treasuryout.each do |cout|
        cout[0][0][1] = Currency.where(id: cout[0][0][1]).map(&:currency)*","
      end
      #Change currency code by currency name
      @treasury.each do |ctr|
        ctr[0][0][1] = Currency.where(id: ctr[0][0][1]).map(&:currency)*","
      end

      #ORDER ARRAYS
      @treasuryin = @treasuryin.sort
      @treasuryout = @treasuryout.sort
      @treasury = @treasury.sort


      # merge amount in with amount
      @treasury.each do |tr|
        @treasuryout.each do |vout|
          if tr[0][0][1] == vout[0][0][1] and tr[0][1][1] == vout[0][1][1]
            tr[1] = tr[1] + vout[1]
            tr[1] = tr[1]
          end
        end
      end

      i=0
      @j = []
      @treasuryout.each do |vout|
        flag = 0
        #change labels
        vout[0][0][0] = 'currency'
        vout[0][1][0] = 'from'
        j=0
        @treasury.each do |tr|
          if @treasury[j][0] == @treasuryout[i][0]
            flag = 1
          end
          j += 1
        end
        if flag == 0
          @j << @treasuryout[i]
          @treasury += @j
          @j= []
        end
        i += 1
      end

      i=0
      #remove user world
      @treasury.each do |tr|
        if tr[0][1][1] == '66vVRjoK9ZA8qy'
          tr[0][1][1] = ''
          tr[0][1][0] = ''
          tr[1]=''
        end
        i += 1
      end

      i=0
      @treasuryin.each do |tr|
        if tr[0][1][1] == '66vVRjoK9ZA8qy'
          tr[0][1][1] = ''
          tr[0][1][0] = ''
          tr[1]=''
        end
        i += 1
      end

      i=0
      @treasuryout.each do |tr|
        if tr[0][1][1] == '66vVRjoK9ZA8qy'
          tr[0][1][1] = ''
          tr[0][1][0] = ''
          tr[1]=''
        end
        i += 1
      end





      @header = @treasury.dup
      @header = @header.uniq! {|c| [c[0][0][1]]}
      @rows = @treasury.dup
      @rows = @rows.uniq! {|c| [c[0][1][1]]}

      @totals = Array.new(4) { Array.new() }
      #Totals
      i=0
      @header.each do |totals|
        @totals[0][i] = totals[0][0][1]
        i += 1
      end



      #Sum currencies
      i=0
      val = 0
      total = 0
      @totals[1][2] = 0
      @rows.each do |users|
        @header.each do |currency|
          @totals[1][i] = 0
          total = 0
          @treasury.each do |values|
            if values[0][0][1] == currency[0][0][1]
              if @totals[1][i] == nil
                @totals[1][i] = 0
              end
              @totals[1][i] += values[1].to_f
              @totals[1][i] = @totals[1][i]
            end
          end
          i += 1
        end

      end
      #Enter rates in array and compute equivalent total
      @currencies = Currency.all
      i=0
      @header.each do |header|
        rate = @currencies.where(currency: @totals[0][i]).map(&:exch_rate)*","
        if rate != nil and rate != ''
          if @totals[3][i] == nil
            @totals[3][i] = 0
          end
          @totals[2][i] = rate.to_f
          #if @totals[1][i] > 0
            if @totals[3][i] == nil
              @totals[3][i] = 0
            end
            if @totals[1][i].to_f > 0 and rate.to_f > 0
              @totals[3][i] += rate.to_f * @totals[1][i].to_f #).round(1)
            elsif @totals[1][i].to_f < 0 and rate.to_f > 0
              @totals[3][i] += rate.to_f * (@totals[1][i].to_f * -1)
              @totals[3][i] = @totals[3][i] * -1
            end
            @totals[3][i] = @totals[3][i]
          #end
        else
          @totals[2][i] = 0
          @totals[3][i] = 0
        end
        i += 1
      end

    end

    def tresuryCoinbagBalance
      #Get world user id
      @worldId = User.where(username: 'world').map(&:id)*","
      @world = User.where(username: 'world')
      #load members to filter table
      @members = User.all
      @members = @members.order(:nickname)
      @members = @members - @world
     #@members.find(@worldId).destroy

      @currenciesCoin = Currency.all
      @currenciesCoin = @currenciesCoin.order(:currency)

      @treasuryIn = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['from'].eq("#{@default_member}") &
          doc['coinbag'].ne('')
          }.
        group('coinbag','currency').
        sum{|value| value['amount'] * (-1) - value['fee']}
      }

      #Just to get the income
      @treasuryOut = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['to'].eq("#{@default_member}") &
          doc['coinbag_dest'].ne('')
          }.
        group('coinbag_dest','currency_dest').
        sum{|value| value['amount_dest']}
      }

      #Just to get the TOTAL OUT
      @TotalsOut = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['from'].eq("#{@default_member}") &
          doc['coinbag'].ne('')
          }.
        group('currency').
        sum{|value| value['amount'] * (-1) - value['fee']}
      }

      #Just to get the TOTAL IN
      @TotalsIn = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['to'].eq("#{@default_member}") &
          doc['coinbag_dest'].ne('')
          }.
        group('currency_dest').
        sum{|value| value['amount_dest']}
      }

      #Just to get the COINBAGS OUT
      @coinbagsOut = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['from'].eq("#{@default_member}") &
          doc['coinbag'].ne('')
          }.
        group('coinbag').
        sum{|value| value['amount'] * (-1) - value['fee']}
      }

      #Just to get the COINBAGS IN
      @coinbagsIn = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['to'].eq("#{@default_member}") &
          doc['coinbag_dest'].ne('')
          }.
        group('coinbag_dest').
        sum{|value| value['amount_dest']}
      }

      #Merge coinbags IN with OUT
      @CoinbagsCoin = @coinbagsIn.merge(@coinbagsOut){|key, oldval, newval| newval + oldval}

      #Get coinbags names
      @CoinbagsCoin = @CoinbagsCoin.update(@CoinbagsCoin) {
         |key, value| Coinbag.where(id: key).map(&:coinbag)*"," }
      #Order hash
      @CoinbagsCoin = Hash[@CoinbagsCoin.sort_by{|k, v| v}]


      #TOTALS
      @SumValues = @TotalsIn.merge(@TotalsOut){|key, oldval, newval| newval + oldval}


      #Merge Totals IN with OUT and HEADERs
      @TotalsCoin = @TotalsIn.merge(@TotalsOut){|key, oldval, newval| newval + oldval}
      #Get currencies names
      @TotalsCoin = @TotalsCoin.update(@TotalsCoin) {
         |key, value| Currency.where(id: key).map(&:currency)*"," }
      #Order hash
      @TotalsCoin = Hash[@TotalsCoin.sort_by{|k, v| v}]


      @ValuesCoin = @treasuryIn.merge(@treasuryOut){|key, oldval, newval| newval + oldval}

    end

    def tresuryCategoryBalance
      #Get world user id
      @worldId = User.where(username: 'world').map(&:id)*","
      @world = User.where(username: 'world')
      #load members to filter table
      @members = User.all
      @members = @members.order(:nickname)
      @members = @members - @world
     #@members.find(@worldId).destroy

      @currenciesCoin = Currency.all
      @currenciesCoin = @currenciesCoin.order(:currency)

      @C_treasuryIn = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['from'].eq("#{@default_member}")
          }.
        group('classification','currency').
        sum{|value| value['amount'] * (-1) - value['fee']}
      }

      #Just to get the income
      @C_treasuryOut = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['to'].eq("#{@default_member}")
          }.
        group('classification','currency_dest').
        sum{|value| value['amount_dest']}
      }

      #Just to get the TOTAL OUT
      @C_TotalsOut = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['from'].eq("#{@default_member}")
          }.
        group('currency').
        sum{|value| value['amount'] * (-1) - value['fee']}
      }

      #Just to get the TOTAL IN
      @C_TotalsIn = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['to'].eq("#{@default_member}")
          }.
        group('currency_dest').
        sum{|value| value['amount_dest']}
      }

      #Just to get the COINBAGS OUT
      @categoryOut = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['from'].eq("#{@default_member}")
          }.
        group('classification').
        sum{|value| value['amount'] * (-1) - value['fee']}
      }

      #Just to get the COINBAGS IN
      @categoryIn = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
        filter{ |doc| doc['status'].eq("I") &
          doc['to'].eq("#{@default_member}")
          }.
        group('classification').
        sum{|value| value['amount_dest']}
      }

      #Merge coinbags IN with OUT
      @CategoryCoin = @categoryIn.merge(@categoryOut){|key, oldval, newval| newval + oldval}

      #Get coinbags names
      @CategoryCoin = @CategoryCoin.update(@CategoryCoin) {
         |key, value| Classification.where(id: key).map(&:classification)*"," }
      #Order hash
      @CategoryCoin = Hash[@CategoryCoin.sort_by{|k, v| v}]


      #TOTALS
      @C_SumValues = @C_TotalsIn.merge(@C_TotalsOut){|key, oldval, newval| newval + oldval}


      #Merge Totals IN with OUT and HEADERs
      @C_TotalsCoin = @C_TotalsIn.merge(@C_TotalsOut){|key, oldval, newval| newval + oldval}
      #Get currencies names
      @C_TotalsCoin = @C_TotalsCoin.update(@C_TotalsCoin) {
         |key, value| Currency.where(id: key).map(&:currency)*"," }
      #Order hash
      @C_TotalsCoin = Hash[@C_TotalsCoin.sort_by{|k, v| v}]


      @C_ValuesCoin = @C_treasuryIn.merge(@C_treasuryOut){|key, oldval, newval| newval + oldval}

    end


end
