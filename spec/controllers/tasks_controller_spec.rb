#
# TeamPlayer -- 2014
#
# This file tests the TasksController functionality 
#

require 'spec_helper'

describe TasksController do

#tests for new

# tests for getall

# send back date start date end
# receive back all the tasks within that range

describe "TEST get_task_in_range" do

	context "tasks within month range" do

		  # given (through get) range: date[start] <= task[:created_at] <= date[end]

		# range is not formatted correctly- end is earlier than start
		it 'should send back a range' do
			post 'task_in_range', :range => {:start => "6-16-2014", :end => "4-16-2014"}
			(response.status = 400).should be_true
		end

		# range is only one date
		it 'should send back a range' do
			post 'task_in_range', :range => {:start => "5-16-2014", :end => "5/16/2014"}
			(response.status = 400).should be_true
		end

		# range is not formatted correctly
		it 'should send back a range' do
			post 'task_in_range', :range => {:start => "5-16-2014", :end => "5/16/2014"}
			(response.status = 400).should be_true
		end

	end

end


end