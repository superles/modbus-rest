class HelpController < ApplicationController
  def index
  end

  def write
    @conf= Cfg.new
    @conf.loadfile
  end

  def read
    @conf= Cfg.new
    @conf.loadfile
  end
end
