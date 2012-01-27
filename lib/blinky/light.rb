module Blinky
  class Light
    INTERFACE_ID = 0
    
    def initialize device, recipe, plugins
        @handle = device.usb_open
        @handle.set_configuration(device.configurations.first)
        @handle.claim_interface(INTERFACE_ID)
        self.extend(recipe)   
        plugins.each do |plugin|
            self.extend(plugin)
        end          
    end
    
    def where_are_you?
      5.times do
        failure!
        sleep(0.5)
        success!
        sleep(0.5)
      end
      off!      
    end

    def close
      @handle.release_interface(INTERFACE_ID)
      @handle.usb_close
      @handle = nil
    end
    
  end
end
