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

  def unattending_users
    attending_users = @event.attendees.where('status >= ?', 0) + [@event.creator]
    attending_ids = attending_users.pluck(:id)
    User.where.not(id: attending_ids)
  end

  def attending
    current_user.attendances.find_by(event_id: @event.id)
  end
end
