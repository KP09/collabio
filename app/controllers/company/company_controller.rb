class Company::CompanyController < ApplicationController
  # Checks whether the current user is a company
  before_action :enforce_company_rights
  layout "dashboard"

  # Skips pundit checks because we define rights outside of Pundit
  skip_after_action :verify_authorized, except: :index, unless: :skip_pundit?
  skip_after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  private

  # Returns true if the user is logged in and is a company
  def enforce_company_rights
    redirect_to root_path unless current_user && current_user.company
  end
end
