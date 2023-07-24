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
end
