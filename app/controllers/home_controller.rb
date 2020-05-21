class HomeController < ApplicationController
  def index
    @test = t('say_hello')
    # @test1 = t('hello')
  end
end
