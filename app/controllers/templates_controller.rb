class TemplatesController < ApplicationController
  layout :false, :only => [:new, :edit, :summary]

  before_filter :check_user
  before_filter :check_me, :except => [:index, :new, :create]

  def index
    #@templates = current_user.templates
    @templates = Template.all
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(params[:template])
    @template.save 
  end

  def show
    #@template = Template.find(params[:id])
  end

  def summary
    #@template = Template.find(params[:id])
  end

  def edit
    #@template = Template.find(params[:id])
  end

  def update
    #@template = Template.find(params[:id])
    @template.update_attributes(params[:template]) 
  end

  def destroy
    #@template = Template.find(params[:id])
    @template.destroy if @template.can_destroy?
    redirect_to templates_path
  end

  private
  def check_me
    @template = Template.find(params[:id])
    redirect_to templates_path if !@template.user.nil? && @template.user != current_user
  end
end
