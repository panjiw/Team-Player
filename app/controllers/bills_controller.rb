class BillsController < ApplicationController
  def new
    @bill = Bill.new(group_id: params[:bill][:group_id],
                     user_id: params[:bill][:creator_id],
                     title: params[:bill][:title],
                     description: params[:bill][:description],
                     due_date: params[:bill][:due_date],
                     total_due: params[:bill][:total_due])
    if @bill.save
      total_count = 0

      # check correct division first
      params[:bill][:members].each do |m|
        total_count = total_count + m[:due]
      end
      if total_count != @bill[:total_due]
        @bill.destroy
        render :json => {:errors => "Total due is not divided correctly"}, :status => 400
      end

      actors_not_added = true
      params[:bill][:members].each do |m|
        @bill_actor = BillActor.new(bill_id: @bill[:id],
                                    user_id: @bill[:user_id],
                                    due: m[:due],
                                    paid: false)
        if !@bill_actor.save
          # could be replaced by association destroy
          BillActor.find_by_bill_id(@bill[:id]).each do |a|
            a.destroy
          end
          @bill.destroy
          render :json => {:errors => @bill_actor.errors.full_messages}, :status => 400
        end
      end
      render :json => {:bill => "OK"}, :status => 200
    else
      render :json => {:errors => @bill.errors.full_messages}, :status => 400
    end
  end

  def get_all

  end
end
