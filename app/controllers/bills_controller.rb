require 'json'

class BillsController < ApplicationController
  before_action :signed_in_user
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
    bill = params[:bill]
    @bill = Bill.new(group_id: bill[:group_id],
                     user_id: view_context.current_user[:id],
                     title: bill[:title],
                     description: bill[:description],
                     due_date: bill[:due_date],
                     total_due: bill[:total_due])
    if @bill.save
      total_count = 0

      # check correct division
      bill[:members].each do |m|
        total_count = total_count + m[1].to_f
      end
      diff = total_count - @bill[:total_due]
      if diff.abs > 1
        @bill.destroy
        render :json => {:errors => "Total due is not divided correctly"}, :status => 400
      else
        bill[:members].each do |m|
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
        if !@bill.bill_actors.find_by_user_id(view_context.current_user[:id])
          @bill_actor = BillActor.new(bill_id: @bill[:id],
                                      user_id: view_context.current_user[:id],
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
    bills = {}
    count = 0
    view_context.current_user.bills.each do |b|
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
  end

  # Mark the bill with the given id as finished
  # Returns the info of the bill
  def mark_finished
    bill = Bill.find(params[:bill][:id])
    if bill.nil?
      render :json => {:errors => "Invalid bill"}, :status => 400
    else
      bill_actor = bill.bill_actors.find_by_user_id(params[:bill_actor][:id])
      if bill_actor.nil?
        render :json => {:errors => "Unauthorized action"}, :status => 400
      else
        bill_actor.update(paid: true, paid_date: Date.today)
        result = {}
        result[:details] = bill
        result[:due] = {}
        bill.bill_actors.each do |a|
          result[:due][a[:user_id]] = {:due => a[:due], :paid => a[:paid], :paid_date => a[:paid_date]}
        end
        render :json => result.to_json, :status => 200
      end
    end
  end

  # Update the given bill with the given attribute
  def edit
    bill = params[:bill]
    @bill = Bill.find(bill[:id])
    if !@bill.bill_actors.find_by_user_id(view_context.current_user[:id]) && @bill.user != view_context.current_user
      render :json => {:errors => "Unauthorized action"}, :status => 400
    else
      @bill.group_id = bill[:group_id]
      @bill.user_id = view_context.current_user[:id]
      @bill.title = bill[:title]
      @bill.description = bill[:description]
      @bill.due_date = bill[:due_date]
      @bill.total_due = bill[:total_due]
      total_count = 0
      # check correct division
      bill[:members].each do |m|
        total_count = total_count + m[1].to_f
      end
      
      @bill.bill_actors.each do |a|
        if a.paid && a.user_id != current_user.id
          render :json => {:errors => "You cannot edit a partially paid bill"}, :status => 400
          return
        end
      end

      if total_count != @bill[:total_due]
        render :json => {:errors => "Total due is not divided correctly"}, :status => 400
      else
        if @bill.save
          @bill.bill_actors.delete_all
          bill[:members].each do |m|
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
          if !@bill.bill_actors.find_by_user_id(view_context.current_user[:id])
            @bill_actor = BillActor.new(bill_id: @bill[:id],
                                        user_id: view_context.current_user[:id],
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
  end

  # Delete the given bill
  def delete
    @bill = Bill.find(params[:bill][:id])
    if !@bill.bill_actors.find_by_user_id(view_context.current_user[:id]) && !@bill.user != view_context.current_user
      render :json => {:errors => "Unauthorized action"}, :status => 400
    else
      @bill.destroy
      render :json => {:status => "success"}, :status => 200
    end
  end

  # Returns all the bills of the signed in user within the
  # given (through post) range: date[start] <= bill[:due_date] <= date[end]
  # Same format as get_all
  def get_in_range
    start_date = Date.parse(params[:date][:start])
    end_date = Date.parse(params[:date][:end])
    bills = {}
    count = 0
    view_context.current_user.bills.where(due_date: start_date..end_date).each do |b|
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
  end
end
