class PublicController < ApplicationController

  def admisions
    @groups = Group.all
  end

end
