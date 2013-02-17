class TemplatesController < ApplicationController
  def index
    @templates = current_user.templates
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(params[:template])
    @template.save 
  end

  def show
    @template = Template.find(params[:id])
  end

  def edit
    @template = Template.find(params[:id])
  end

  def update
    @template = Template.find(params[:id])
    @template.update_attributes(params[:template]) 
  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy 
  end
end
