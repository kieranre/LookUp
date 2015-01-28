require 'spec_helper'

describe Roof do

  context 'Roof material' do

    it "knows the material that the roof is made out of" do
      @roof = Roof.create
      visit "/roofs/#{@roof.id}/material/edit"
      choose("Tiles")
      click_on "Next"
      expect(Roof.first.material).to eq "Tiles"
    end

  end

  context 'Shading value' do

    it 'holds the specific shade value set by the user' do
      @roof = Roof.create
      visit "/roofs/#{@roof.id}/shading/edit"
      fill_in "shade_value", with: "10"
      click_on "Next"
      expect(Roof.first.shade_value).to eq 10
    end

  end

  context 'Roof angle' do

    it 'records a 0 degree angle for flat roofs' do
      @roof = Roof.create
      visit "/roofs/#{@roof.id}/start"
      click_on 'Flat'
      expect(Roof.first.roof_angle).to eq 0
    end

    it 'records the specific angle of the roof if it is sloped' do
      @roof = Roof.create
      visit "/roofs/#{@roof.id}/sloped/edit"
      click_on 'Capture'
      expect(Roof.first.roof_angle).to eq 0
    end

  end

  context 'Saving user data' do

    it "saves the user's name, email and the site's title" do
      @roof = Roof.create(roof_angle: 0, angled_edge: 10, gutter_edge: 20, shade_value: 10)
      visit "/roofs/#{@roof.id}/capacity/edit"
      fill_in 'title', with: 'Test Roof'
      fill_in 'discovered_by', with: 'Test User'
      fill_in 'email', with: 'test@test.com'
      click_on 'Send me the results'
      expect(Roof.first.title).to eq 'Test Roof'
      expect(Roof.first.discovered_by).to eq 'Test User'
      expect(Roof.first.user_email).to eq "test@test.com"
    end 

  end

  context 'Results for flat roofs' do

    before(:each) do 
      @roof = Roof.create(gutter_edge: 20, angled_edge: 10, roof_angle: 0, shade_value: 20)
      @roof.set_capacities
    end

    it 'calculates the amount of solar panels that a flat roof can hold' do      
      expect(@roof.panel_capacity).to eq 62        
    end

    it 'calculates power outputs of its estimated solar panels' do
      expect(@roof.power_capacity).to eq 15500
    end

  end

  context 'Results for sloped roofs' do

    before(:each) do
      @roof = Roof.create(roof_angle: 10, gutter_edge: 20, angled_edge: 10, shade_value: 20)
      @roof.set_capacities
    end

    it 'calculates the amount of solar panels that a sloped roof can hold' do
      expect(@roof.panel_capacity).to eq 100
    end

    it 'calculates power outputs of its estimates solar panels' do
      expect(@roof.power_capacity).to eq 25000
    end

    end

end
