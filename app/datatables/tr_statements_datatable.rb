class TrStatementsDatatable
  delegate :params, :dtIni, :dtEnd, :edit_tr_statement_path, :raw, :mail_to, :link_to, to: :@view
  require 'will_paginate'
  require 'will_paginate/array'
  require 'will_paginate/active_record'

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      dtIni: $dt_ini,
      dtEnd: $dt_end,
      sEcho: params[:sEcho].to_i,
      iTotalRecords: transactions.count,
      iTotalDisplayRecords: transactions.total_entries,
      aaData: data
    }
  end

private

  def data
    i = -1
    transactions.map do
      transactions[i+=1]
    end
  end

  def transactions
    @transactions ||= fetch_transactions
  end

  def fetch_transactions

    dateini_to = Time.new(Time.now.year,Time.now.month,Time.now.day,1,45,45,"+00:00")
    dateini_from = Time.new(Time.now.year,Time.now.month,Time.now.day,1,45,45,"+00:00") - 60.days

    if sort_direction == "asc"
      transactions = NoBrainer.run(:profile => false) { |r|
        r.table('tr_statements').filter{|doc| (doc['status'].eq("I") | doc['status'].eq("A")) & doc['date_time'].during(dateini_from, dateini_to) &
          (doc['created_by'].eq($session_id) | doc['from'].eq($session_id) | doc['to'].eq($session_id))}.
        map{ |lista|
          {
            :id => lista["id"],
            :mov_type => lista["mov_type"],
            #:date_time => lista["date_time"].to_epoch_time,
            #:date_time => DateTime.parse(lista["date_time"]).iso8601(9),
            :date_time => lista["date_time"].to_iso8601,
            :detail => lista["detail"],
            :classification => r.table('classifications').filter({id: lista["classification"]}).get_field('classification').reduce{ |left, right| left+right}.default(''),
            :coinbag => r.table('coinbags').filter({id: lista["coinbag"]}).get_field('coinbag').reduce{ |left, right| left+right}.default(""),
            :amount => lista["amount"],
            :currency => r.table('currencies').filter({id: lista["currency"]}).get_field('currency').reduce{ |left, right| left+right}.default(""),
            :from => r.table('users').filter({id: lista["from"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :to => r.table('users').filter({id: lista["to"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :coinbag_dest => r.table('coinbags').filter({id: lista["coinbag_dest"]}).get_field('coinbag').reduce{ |left, right| left+right}.default(""),
            :currency_dest => r.table('currencies').filter({id: lista["currency_dest"]}).get_field('currency').reduce{ |left, right| left+right}.default(""),
            :amount_dest => lista["amount_dest"],
            :celebrate => lista["celebrate"],
            :created_by => lista["created_by"],
            :from_id => lista["from"],
            :to_id => lista["to"],
            :status => lista["status"],
            :hash => lista["hash"],
            :author => r.table('users').filter({id: lista["created_by"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :session_id => $session_id
            #:dateini => "#{dateini_from.year}-#{dateini_from.month}-#{dateini_from.day}",
            #:dateend => "#{dateini_to.year}-#{dateini_to.month}-#{dateini_to.day}"
          }
        }.
        order_by(r.desc("#{sort_column}"))
      }
    else
      transactions = NoBrainer.run(:profile => false) { |r|
        r.table('tr_statements').filter{|doc| (doc['status'].eq("I") | doc['status'].eq("A")) & doc['date_time'].during(dateini_from, dateini_to) &
          (doc['created_by'].eq($session_id) | doc['from'].eq($session_id) | doc['to'].eq($session_id))}.
        map{ |lista|
          {
            :id => lista["id"],
            :mov_type => lista["mov_type"],
            #:date_time => lista["date_time"].to_epoch_time,
            :date_time => lista["date_time"],
            :detail => lista["detail"],
            :classification => r.table('classifications').filter({id: lista["classification"]}).get_field('classification').reduce{ |left, right| left+right}.default(''),
            :coinbag => r.table('coinbags').filter({id: lista["coinbag"]}).get_field('coinbag').reduce{ |left, right| left+right}.default(""),
            :amount => lista["amount"],
            :currency => r.table('currencies').filter({id: lista["currency"]}).get_field('currency').reduce{ |left, right| left+right}.default(""),
            :from => r.table('users').filter({id: lista["from"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :to => r.table('users').filter({id: lista["to"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :coinbag_dest => r.table('coinbags').filter({id: lista["coinbag_dest"]}).get_field('coinbag').reduce{ |left, right| left+right}.default(""),
            :currency_dest => r.table('currencies').filter({id: lista["currency_dest"]}).get_field('currency').reduce{ |left, right| left+right}.default(""),
            :amount_dest => lista["amount_dest"],
            :celebrate => lista["celebrate"],
            :created_by => lista["created_by"],
            :from_id => lista["from"],
            :to_id => lista["to"],
            :status => lista["status"],
            :hash => lista["hash"],
            :author => r.table('users').filter({id: lista["created_by"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :session_user => $session_id
            #:dateini => "#{dateini_from.year}-#{dateini_from.month}-#{dateini_from.day}",
            #:dateend => "#{dateini_to.year}-#{dateini_to.month}-#{dateini_to.day}"
          }
        }.
        order_by(r.asc("#{sort_column}"))
      }
    end

    date_from = dateini_from
    date_to = dateini_to

    if params[:datefrom] != '' or params[:amountfrom].to_f > 0 or params[:amountto].to_f > 0 or params[:category].present? or
      params[:sSearch].present? or params[:coinbag].present? or params[:currency].present? or params[:author].present? or params[:user].present?

      if params[:datefrom] != ''
        date_from = Time.new(params[:datefrom][0..3].to_i,params[:datefrom][5..6].to_i,params[:datefrom][8..9].to_i,1,45,45,"+00:00")
        date_to = Time.new(params[:dateto][0..3].to_i,params[:dateto][5..6].to_i,params[:dateto][8..9].to_i,1,45,45,"+00:00") + 1
      else
        date_from = dateini_from
        date_to = dateini_to
      end

      amount_flag = false
      if params[:amountfrom].delete(' ') != '' and params[:amountto].delete(' ') != ''
        amount_from = params[:amountfrom].to_f
        amount_to = params[:amountto].to_f
        amount_flag = true
      elsif params[:amountfrom].delete(' ') != '' and params[:amountto].delete(' ') == ''
        amount_from = params[:amountfrom].to_f
        amount_to = 99999999999999999999999999999
        amount_flag = true
      elsif params[:amountfrom].delete(' ') == '' and params[:amountto].delete(' ') != ''
        amount_from = 0
        amount_to = params[:amountto].to_f
        amount_flag = true
      end


      transactions = NoBrainer.run(:profile => false) { |r|
        r.table('tr_statements').filter{|doc| (
          r.branch(params[:datefrom] != '', doc['date_time'].during(date_from, date_to), doc['date_time']) &
          r.branch(amount_flag == true,doc['amount'].gt(amount_from) & doc['amount'].lt(amount_to),doc['amount']) &
          (r.branch(params[:sSearch] != '', doc['detail'].downcase().match("#{params[:sSearch]}".downcase), doc['detail']) |
          r.branch(params[:sSearch] != '', doc['celebrate'].downcase().match("#{params[:sSearch]}".downcase), doc['celebrate'])) &
          r.branch(params[:category] != '', doc['classification'].eq(params[:category]),doc['classification']) &
          (r.branch(params[:user] != '', doc['from'].eq(params[:user]),doc['from'].eq($session_id)) |
          r.branch(params[:user] != '', doc['to'].eq(params[:user]), doc['to'].eq($session_id))) &
          (r.branch(params[:coinbag].delete(' ') != '' && doc['coinbag'].ne(''), doc['coinbag'].match(params[:coinbag]),true) |
          r.branch(params[:coinbag].delete(' ') != '' && doc['coinbag_dest'].ne(''), doc['coinbag_dest'].match(params[:coinbag]),true)) &
          (r.branch(params[:currency] != '', doc['currency'].eq(params[:currency]),true) |
          r.branch(params[:currency] != '', doc['currency_dest'].eq(params[:currency]),doc['currency_dest'])) &
          r.branch(params[:author] != '', doc['created_by'].eq(params[:author]),doc['created_by']) &
          (doc['status'].eq("I") | doc['status'].eq("A"))
          )}.
        map{ |lista|
          {
            :id => lista["id"],
            :mov_type => lista["mov_type"],
            :date_time => lista["date_time"],
            :detail => lista["detail"],
            :classification => r.table('classifications').filter({id: lista["classification"]}).get_field('classification').reduce{ |left, right| left+right}.default(''),
            :coinbag => r.table('coinbags').filter({id: lista["coinbag"]}).get_field('coinbag').reduce{ |left, right| left+right}.default(""),
            :amount => lista["amount"],
            :currency => r.table('currencies').filter({id: lista["currency"]}).get_field('currency').reduce{ |left, right| left+right}.default(""),
            :from => r.table('users').filter({id: lista["from"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :to => r.table('users').filter({id: lista["to"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :coinbag_dest => r.table('coinbags').filter({id: lista["coinbag_dest"]}).get_field('coinbag').reduce{ |left, right| left+right}.default(""),
            :currency_dest => r.table('currencies').filter({id: lista["currency_dest"]}).get_field('currency').reduce{ |left, right| left+right}.default(""),
            :amount_dest => lista["amount_dest"],
            :celebrate => lista["celebrate"],
            :created_by => lista["created_by"],
            :from_id => lista["from"],
            :to_id => lista["to"],
            :status => lista["status"],
            :hash => lista["hash"],
            :author => r.table('users').filter({id: lista["created_by"]}).get_field('nickname').reduce{ |left, right| left+right}.default(""),
            :session_id => $session_id
            #:dateini => "#{date_from.year}-#{date_from.month}-#{date_from.day}",
            #:dateend => "#{date_to.year}-#{date_to.month}-#{date_to.day}"
          }
        }.
        order_by(r.desc("#{sort_column}"))
      }

    end

    $dt_ini = date_from
    $dt_end = date_to

    transactions = transactions.to_a
    transactions = transactions.paginate(:page => page, :per_page => per_page)

    #$transactions = transactions.count

    transactions
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[date_time date_time classification from to currency amount]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def aditional_params
    filter_coinbag = params[:coinbag]
  end
end
