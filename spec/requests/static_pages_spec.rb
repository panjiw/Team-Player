require 'spec_helper'

describe "StaticPages" do
  subject { page }
  describe "home page" do
    before { visit home_path }

    it { should have_content('home') }
  end
  describe "index page" do
    before { visit index_path }

    it { should have_content('index') }
  end
end
