class SessionsController < ApplicationController
  def new_session
    cookies.permanent[:session] = Session.create.identifier
    return redirect_to :back if request.env['HTTP_REFERER']
    return redirect_to root_path
  end

  def delete_session
    Session.find_by_identifier(cookies.permanent[:session]).delete rescue nil
    cookies.permanent[:session] = nil
    redirect_to new_session_path
  end

  def log
    session = Session.find_by_identifier(cookies.permanent[:session])
    session.update_attribute(:completed_to, params[:time])
    return redirect_to :back
  end

  def add_source
    return redirect_to :back unless SOURCES.include?(params[:source])
    Session.find_by_identifier(cookies.permanent[:session]).update_sources(params[:source])
    return redirect_to :back
  end

  def share
    session = Session.find_by_identifier(cookies.permanent[:session])
    redirect_to root_path + session.identifier
  end
end