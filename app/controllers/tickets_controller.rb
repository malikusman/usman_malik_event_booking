# frozen_string_literal: true

# Handles listing tickets for a given Event
class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def index
    @tickets = @event.tickets.includes(:user)
  end

  def new
    @ticket = @event.tickets.build
  end

  def create
    service = Tickets::CreateService.new(@event, current_user, ticket_params[:quantity].to_i)

    begin
      @ticket = service.call
      redirect_to event_tickets_path(@event), notice: 'Tickets booked successfully.'
    rescue StandardError => e
      flash.now[:alert] = e.message
      @ticket = @event.tickets.build(ticket_params)
      render :new, status: 422
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def ticket_params
    params.require(:ticket).permit(:quantity)
  end
end
