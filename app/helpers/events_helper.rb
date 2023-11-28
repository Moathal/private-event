# frozen_string_literal: true

module EventsHelper
  def accept_invite_with_attend_record(user_attend)
    if user_attend.status == 'canceled'
      flash[:error] = 'Invitation has been canceled.'
    else
      user_attend.update(status: :accepted, invited_user: true)
    end
  end

  def reject_invite_with_attend_record(user_attend)
    if user_attend.status == 'canceled'
      flash[:error] = 'Invitation has been canceled.'
      redirect_to @event
    else
      user_attend.update(status: :rejected, invited_user: true)
    end
  end

  def mark_current_user_event_notifications_as_read
    notifications = current_user.notifications.where("params->> 'event_id' = ? AND read_at IS NULL", @event.id.to_s)
    return if notifications.empty?

    notifications.each(&:mark_as_read!)
  end

  def update_page
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('attendances', partial: 'events/attendances',
                                                                 locals: { event: @event,
                                                                           creator: @event.creator,
                                                                           attendances: @event.attendances,
                                                                           attend: attending, unattending_users:,
                                                                           logged_in_user: current_user })
      end
    end
  end

  def unattending_users
    return [] if @event.nil?

    attending_users = Attendance.where.not(status: ["canceled", "rejected"]).where(event_id: @event.id)
    attending_ids = attending_users.pluck(:id) + [ @event.creator_id ]
    User.where.not(id: attending_ids)
  end

  def attending
    current_user.attendances.find_by(event_id: @event.id)
  end

  def attendance_decider
    user_event = current_user.attended_events.where(id: @event.id)
    if !user_event.present?
      attendance = Attendance.new(event_id: @event.id, attendee_id: current_user.id, host_id: @event.creator_id,
                                  status: :accepted, invited_user: false, event: @event)
      Attendance.notify_recipient('attend', @event, @event.creator, current_user, @event.id) if attendance.save!
    else
      attendance_cancel_or_accept(current_user, @event)
    end
  end

  def attendance_cancel_or_accept(current_user, event)
    attendance = Attendance.find_by(event_id: event.id, attendee_id: current_user.id)
    if attendance.status != 'accepted'
      attendance.update(status: 'accepted')
      Attendance.notify_recipient('attend', event, event.creator, current_user, event.id)
    else
      Attendance.notify_recipient('cancel_attend', event, event.creator, current_user, event.id)
      attendance = current_user.attendances.find_by(event_id: event.id)
      attendance.destroy
    end
  end
end
