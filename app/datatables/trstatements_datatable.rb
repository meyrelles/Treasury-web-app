

class TrStatementsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: TrStatement.count,
      iTotalDisplayRecords: tr_statements.total_entries,
      aaData: data
    }
  end

private

  def data
    tr_statements.map do |trstatment|
      [
        link_to(trstatment.created_by, trstatment),
        h(trstatment.currency),
        h(trstatment.date_time.strftime("%B %e, %Y")),
        number_to_currency(trstatment.amount)
      ]
    end
  end

  def tr_statements
    @tr_statements ||= fetch_tr_statements
  end

  def fetch_tr_statements
    tr_statements = TrStatement.order("#{sort_column} #{sort_direction}")
    tr_statements = tr_statements.page(page).per_page(per_page)
    if params[:sSearch].present?
      tr_statements = tr_statements.where("created_by like :search or from like :search", search: "%#{params[:sSearch]}%")
    end
    tr_statements
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
