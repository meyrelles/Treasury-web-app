json.extract! tr_statement, :id, :uniqueid, :date, :time, :coinbag_dest, :timezone, :description, :reason, :coinbag, :from, :to, :currency, :amount, :celebrate, :systemdt, :created_at, :updated_at
json.url tr_statement_url(tr_statement, format: :json)
