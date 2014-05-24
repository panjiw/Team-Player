require 'json'

class BillsController < ApplicationController
  # Creates a new bill where the creator is the signed in user
  # Accepts post request with format of:
  # Required:
  # bill[group_id]: groupID
  # bill[title]: title
  # bill[total_due]: total
  # bill[members]: {user_id:due, ..., user_id:due}
  # Optional:
  # bill[description]: description
  # bill[due_date]: dateDue
  #
  # See bills model in the front end for more info
  #
  # Returns
  # {"details":{
  # "id":bill id,
  # "group_id":group id of the bill,
  # "user_id":1,
  # "title":bill title,
  # "description": bill_description,
  # "due_date":due date,
  # "total_due":total due,
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "due":{
  # user_id:{
  # "due":amount this user owes,
  # "paid":paid or not,
  # "paid_date":date paid (not yet == null)},
  # ...,
  # user_id:{
  # "due":amount this user owes,
  # "paid":paid or not,
  # "paid_date":date paid (not yet == null)}}}

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

      # check correct division
      params[:bill][:members].each do |m|
        total_count = total_count + m[1].to_f
      end
      if total_count != @bill[:total_due]
        @bill.destroy
        render :json => {:errors => "Total due is not divided correctly"}, :status => 400
      else
        params[:bill][:members].each do |m|
          @bill_actor = BillActor.new(bill_id: @bill[:id],
                                      user_id: m[0],
                                      due: m[1],
                                      paid: false)
          if !@bill_actor.save
            @bill.destroy
            render :json => {:errors => @bill_actor.errors.full_messages}, :status => 400
            return
          end
        end
        if !@bill.bill_actors.find_by_user_id(current_user[:id])
          @bill_actor = BillActor.new(bill_id: @bill[:id],
                                      user_id: current_user[:id],
                                      due: 0,
                                      paid: true)
          if !@bill_actor.save
            @bill.destroy
            render :json => {:errors => @bill_actor.errors.full_messages}, :status => 400
            return
          end
        end
        bill = {}
        bill[:details] = @bill
        bill[:due] = {}
        @bill.bill_actors.each do |a|
          # don't know why just giving a doesn't work
          bill[:due][a[:user_id]] = {:due => a[:due], :paid => a[:paid], :paid_date => a[:paid_date]}
        end
        render :json => bill.to_json, :status => 200
      end
    else
      render :json => {:errors => @bill.errors.full_messages}, :status => 400
    end
  end

  # Returns all the bills of the signed in user
  # {number starting from 0:{"details":{
  # "id":bill id,
  # "group_id":group id of the bill,
  # "user_id":1,
  # "title":bill title,
  # "description": bill_description,
  # "due_date":due date,
  # "total_due":total due,
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "due":{
  # user_id:{
  # "due":amount this user owes,
  # "paid":paid or not,
  # "paid_date":date paid (not yet == null)},
  # ...,
  # user_id:{
  # "due":amount this user owes,
  # "paid":paid or not,
  # "paid_date":date paid (not yet == null)}}}, ...}
  def get_all
    if view_context.signed_in?
      bills = {}
      count = 0
      current_user.bills.each do |b|
        bill = {}
        bill[:details] = b
        bill[:due] = {}
        b.bill_actors.each do |a|
          # don't know why just giving a doesn't work
          bill[:due][a[:user_id]] = {:due => a[:due], :paid => a[:paid], :paid_date => a[:paid_date]}
        end
        bills[count] = bill
        count += 1
      end
      render :json => bills.to_json, :status => 200
    else
      redirect_to '/'
    end
  end

  # Mark the bill with the given id as finished
  # Returns the info of the bill
  def mark_finished
    if view_context.signed_in?
      bill = Bill.find(params[:bill][:id])
      if bill.nil?
        render :json => {:errors => "Invalid bill"}, :status => 400
      else
        bill_actor = bill.bill_actors.find_by_user_id(current_user[:id])
        if bill_actor.nil?
          render :json => {:errors => "Unauthorized action"}, :status => 400
        else
          bill_actor.update(finished: true, paid_date: Date.today)
          result = {}
          result[:details] = bill
          result[:due] = {}
          bill.bill_actors.each do |a|
            result[:due][a[:user_id]] = {:due => a[:due], :paid => a[:paid], :paid_date => a[:paid_date]}
          end
          render :json => result.to_json, :status => 200
        end
      end
    else
      redirect_to '/'
    end
  end

  def edit
    if view_context.signed_in?
      @bill = Bill.find(params[:bill][:id])
      if !@bill.bill_actors.find_by_user_id(view_context.current_user[:id]) && @bill.user != view_context.current_user
        render :json => {:errors => "Unauthorized action"}, :status => 400
      else
        @bill.group_id = params[:bill][:group_id]
        @bill.user_id = view_context.current_user[:id]
        @bill.title = params[:bill][:title]
        @bill.description = params[:bill][:description]
        @bill.due_date = params[:bill][:due_date]
        @bill.total_due = params[:bill][:total_due]
        total_count = 0
        # check correct division
        params[:bill][:members].each do |m|
          total_count = total_count + m[1].to_f
        end
        if total_count != @bill[:total_due]
          render :json => {:errors => "Total due is not divided correctly"}, :status => 400
        else
          if @bill.save
            @bill.bill_actors.delete_all
            params[:bill][:members].each do |m|
              @bill_actor = BillActor.new(bill_id: @bill[:id],
                                          user_id: m[0],
                                          due: m[1],
                                          paid: false)
              if !@bill_actor.save
                @bill.destroy
                render :json => {:errors => @bill_actor.errors.full_messages}, :status => 400
                return
              end
            end
            if !@bill.bill_actors.find_by_user_id(current_user[:id])
              @bill_actor = BillActor.new(bill_id: @bill[:id],
                                          user_id: current_user[:id],
                                          due: 0,
                                          paid: true)
              if !@bill_actor.save
                @bill.destroy
                render :json => {:errors => @bill_actor.errors.full_messages}, :status => 400
                return
              end
            end
            bill = {}
            bill[:details] = @bill
            bill[:due] = {}
            bill_holder = Bill.find(@bill[:id])
            bill_holder.bill_actors.each do |a|
              # don't know why just giving a doesn't work
              bill[:due][a[:user_id]] = {:due => a[:due], :paid => a[:paid], :paid_date => a[:paid_date]}
            end
            render :json => bill.to_json, :status => 200
          else
            render :json => {:errors => @bill.errors.full_messages}, :status => 400
          end
        end
      end
    else
      redirect_to '/'
    end
  end
  def delete
    if view_context.signed_in?
      @bill = Bill.find(params[:bill][:id])
      if !@bill.bill_actors.find_by_user_id(view_context.current_user[:id]) && !@bill.user != view_context.current_user
        render :json => {:errors => "Unauthorized action"}, :status => 400
      else
        @bill.destroy
        render :json => {:status => "success"}, :status => 200
      end
    else
      redirect_to '/'
    end
  end
end
