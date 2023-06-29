module EventsHelper
  def get_unattending_users(event)
    uninvited_ids = event.attendances.where(invited_user: false)
                                    .or(event.attendances.where(status: "rejected"))
                                    .pluck(:user_id)
    invited_ids = event.attendances.where(invited_user: true).pluck(:user_id)
    subquery = User.where.not(id: invited_ids).or(User.where(id: uninvited_ids))
    subquery.distinct
  end

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
