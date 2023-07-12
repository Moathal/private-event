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

  def update_notifications_for_deleted_event(event_id)
    notifications = Notification.where(params: { 'event._aj_globalid' => "gid://private-event/Event/#{event_id}" })
    notifications.each do |notification|
      updated_params = notification.params.deep_dup
      updated_params['event'] = 'deleted'
      notification.update(params: updated_params)
    end
  end
end
