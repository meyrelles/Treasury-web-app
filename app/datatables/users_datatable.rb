class UsersDatatable
  delegate :params, :edit_user_path, :raw, :mail_to, :link_to, to: :@view
  require 'will_paginate'
  require 'will_paginate/array'
  require 'will_paginate/active_record'

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: User.count,
      aaData: data
    }
  end

private

  def data
    #users
    users.map do |user|

      if !user.profile.nil?
        profile = Usergroup.find(user.profile) #where(:id => user.profile)
        profile_name = profile.group_name #profile.group_name
      else
        profile_name=""
      end
      #@groupname = @profile.group_name
      {
        #link_to(user.username, user),
        username: raw(user.username),
        surname: raw(user.surname),
        givenname: raw(user.givenname),
        nickname: raw(user.nickname),
        email: mail_to(user.email),
        id1: raw(user.id),
        id2: raw(user.id),
        status: raw(user.status),
        group: raw(user.group),
        profile: raw(profile_name)
      }
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.all.order_by(:"#{sort_column}"  => :"#{sort_direction}")
    users = users.paginate(:page => page, :per_page => per_page)
    if params[:sSearch].present?
      users = User.where(:or=>[{:username=>/#{params[:sSearch]}/}, {:surname=>/#{params[:sSearch]}/},
        {:givenname=>/#{params[:sSearch]}/}, {:nickname=>/#{params[:sSearch]}/}, {:email=>/#{params[:sSearch]}/}])
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 5
  end

  def sort_column
    columns = %w[id username nickname email]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
