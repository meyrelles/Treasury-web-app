class TreasuriesController < ApplicationController
  require 'will_paginate'
  require 'will_paginate/array'
  require 'will_paginate/active_record'

  #GET
  def index
    @treasuryin = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
      filter{ |doc| doc['status'].eq("I") }.
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
    #@treasury = @treasuryin

    @treasury.each do |values|
      values[0] = values[0].to_a
    end

    @treasuryin.each do |values|
      values[0] = values[0].to_a
    end

    @treasuryout.each do |values|
      values[0] = values[0].to_a
    end


    # merge amount in with amount
    @treasury.each do |tr|
      @treasuryout.each do |vout|
        if tr[0][0][1] == vout[0][0][1] and tr[0][1][1] == vout[0][1][1]
          tr[1] = tr[1] + vout[1]
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

    #sum{|game| game['amount'] * (-1) - game['fee']}

    #ActiveRecord::Base.include_root_in_json = true

    #@treasuries2 = @treasuries2.to_json

    #map {|val| {
    #  'user': r.table('users').get(val['from']).get_field('username'),
    #  'amount': val['amount'],
    #  'currency': r.table('currencies').get(val['currency']).get_field('currency')
    #  }}

    #map {|val| {'from': val['from']}}

    @usr = NoBrainer.run(:profile => false) { |r| r.table('users').
      filter({id: '6KauQZJDx2Izdg'}).
      map {|k| k['username']} }
    #@usr = NoBrainer.run(:profile => false) { |r| r.table('users').filter({id: '6KauQZJDx2Izdg'}).get('username')}
        #map {|val| {'username': val['nickname']}}

    #NoBrainer.run(TrStatement.rql_table)
    #@treasuries = @treasuries.paginate(:page => params[:page], :per_page => 10)
  end


  #POST
  def filters

  end
end
