class SpecsController < ApplicationController
  def instance
    @spec = InstanceSpec.find(params[:id])
    render "show"
  end

  def disk
    @spec = DiskSpec.find(params[:id])
    render "show"
  end

  def network
    @spec = NetworkSpec.find(params[:id])
    render "show"
  end
end
