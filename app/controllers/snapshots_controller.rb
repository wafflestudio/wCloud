class SnapshotsController < ApplicationController
  def index
    @snapshot = current_user.snapshots
  end

  def edit
    @snapshot = Snapshot.find(params[:id])
  end

  def update
    @snapshot = Snapshot.find(params[:id])
    @snapshot.update_attributes(params[:snapshot]) 
  end
end
