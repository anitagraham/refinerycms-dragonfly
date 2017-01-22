# require "spec_helper"

module Refinery
  module Dragonfly

    describe 'refinerycms-dragonfly' do
      refinery_login

      it 'has a default configuration' do
        expect(RefineryDragonfly.config).to exist
      end

      it 'passes it\s configuration to dragonfly' do

      end
      #   it 'changes the default configuration' do
      #
      #   end
      # end
      #
      # describe "attach" do
      # end
      # describe 'it saves an image' do

      # end
    end
  end
end


