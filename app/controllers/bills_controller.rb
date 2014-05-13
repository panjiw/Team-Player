require 'json'

class BillsController < ApplicationController
  def new
    if !view_context.signed_in?
      redirect_to '/'
    end
    @bill = Bill.new(group_id: params[:bill][:group_id],
                     user_id: view_context.current_user[:id],
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

      params[:bill][:members].each do |m|
        @bill_actor = BillActor.new(bill_id: @bill[:id],
                                    user_id: m[:user_id],
                                    due: m[:due],
                                    paid: false)
        if !@bill_actor.save
          @bill.destroy
          render :json => {:errors => @bill_actor.errors.full_messages}, :status => 400
        end
      end
      render :json => @bill.to_json(:include => [:users => {:except => [:created_at, :updated_at, :bill_id]}]), :status => 200
    else
      render :json => {:errors => @bill.errors.full_messages}, :status => 400
    end
  end

  def get_bills
    if view_context.signed_in?
      render :json => {:bill => "OK"}, :status => 200
    else
      redirect_to '/'
    end
  end
end
