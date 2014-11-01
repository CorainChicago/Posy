require 'rails_helper'

RSpec.describe Location, :type => :model do
  it { should have_many :posts }

  describe '#generate_slug' do
    it 'should NOT generate slug if slug IS provided upon creation' do
      tu = Location.create(name: "Testing University", slug: "testing")
      expect(tu.slug).to eq "testing"
    end

    it 'should generate slug if slug is NOT provided upon creation' do
      tu = Location.create(name: "Testing University")
      expect(tu.slug).to eq "testing-university"
    end
  end

end
