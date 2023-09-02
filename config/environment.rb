require 'bundler/setup'
  Bundler.require

  require_all 'lib'


  Menu.new.showTodos

  binding.pry

  # 0