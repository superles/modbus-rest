class CfgController < ApplicationController

  def update
    @cfg = Cfg.new(params[:cfg])
    File.write(File.join(Rails.root,'db','modbus.json'),@cfg.to_json);
    redirect_to '/userconfig'
  end
end
