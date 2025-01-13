# frozen_string_literal: true

# Handles creation of an Event
class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_event, only: %i[show edit update destroy]
  before_action :check_ownership!, only: %i[edit update destroy]

  def index
    @events = Rails.cache.fetch('all_events', expires_in: 5.minutes) do
      Event.upcoming.order(event_date: :asc, event_time: :asc).to_a
    end
  end

  def show; end

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully deleted.'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def check_ownership!
    return if @event.user_id == current_user.id

    redirect_to events_path, alert: 'You are not authorized to modify this event.'
  end

  def event_params
    params.require(:event).permit(
      :name, :description, :location, :event_date, :event_time, :total_tickets
    )
  end
end
