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
end
