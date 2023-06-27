module EventsHelper
  def get_unattending_users(event)
    uninvited_ids = event.attendances.where(invited_user: false)
                                    .or(@event.attendances.where(status: "rejected"))
                                    .pluck(:user_id)
    invited_ids = event.attendances.where(invited_user: true).pluck(:user_id)
    subquery = User.where.not(id__in=invited_ids).or(User.where(id__in=uninvited_ids))
    subquery.distinct
  end


end
