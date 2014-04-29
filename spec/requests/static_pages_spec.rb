require 'spec_helper'

describe "StaticPages" do
  subject { page }
  describe "about page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title('About Us') }
  end
end
