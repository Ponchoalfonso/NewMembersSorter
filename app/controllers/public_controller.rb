class PublicController < ApplicationController

  def admisions
    @admision = Groups.all
  end

end
