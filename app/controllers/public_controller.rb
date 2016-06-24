class PublicController < ApplicationController

  def admisions
    @admisions = Group.all
  end

end
