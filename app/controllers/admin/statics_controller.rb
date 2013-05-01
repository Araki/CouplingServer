# -*- coding: utf-8 -*-

class Admin::StaticsController < AdminController

  def index
  end

  def by_month
    @today = Date.today
    @men = Profile.by_gender(0).by_created_at(@today.months_ago(25)).count(:group => "DATE_FORMAT(created_at, '%Y-%m')")
    @men.default = 0
    @women = Profile.by_gender(1).by_created_at(@today.months_ago(25)).count(:group => "DATE_FORMAT(created_at, '%Y-%m')")
    @women.default = 0
  end

  def by_day
    @today = Date.today
    @men = Profile.by_gender(0).by_created_at(90.days.ago).count(:group => "DATE_FORMAT(created_at, '%Y-%m-%d')")
    @men.default = 0
    @women = Profile.by_gender(1).by_created_at(90.days.ago).count(:group => "DATE_FORMAT(created_at, '%Y-%m-%d')")
    @women.default = 0
  end
end
