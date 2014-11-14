class FlagsController < ApplicationController
  layout 'default.html.erb'

  def new
    @comment = Comment.where(id: params[:id]).first
    @flag = @comment.flags.build
  end

  def create
    comment = Comment.where(id: params[:id]).first

    head 404 and return unless comment

    if comment.flags.create(explanation: params[:flag][:explanation]).persisted?
      head 201
    else
      head 400
    end
  end
end
