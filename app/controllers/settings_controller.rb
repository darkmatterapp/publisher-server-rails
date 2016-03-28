class SettingsController < ApplicationController
  before_action :set_setting, only: [:edit, :update]
  before_action :authorize
  before_action :all_settings
  before_action :set_on_admin_page

  def index
    @page_title = "Settings"
    @slug = "settings"
    render layout: "admin"
  end

  def show
    redirect_to settings_path
  end

  def edit
    @slug = "settings"
    @setting    = Setting.find(params[:id])
    @page_title = "Editing Setting : #{@setting.name}"
    render layout: "admin"
  end

  def update
    @setting = Setting.find(params[:id])

    if @setting.update(setting_params)
      redirect_to settings_path, notice: "Setting was successfully updated."
    else
      render action: "edit"
    end
  end

  private

  def set_setting
    @setting = Setting.find(params[:id])
  end

  def setting_params
    params.require(:setting).permit(
      :name,
      :key,
      :content)
  end

  def all_settings
    @settings = Setting.editable.all
  end
end
