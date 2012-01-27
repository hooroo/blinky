require 'usb'

module Blinky
  class Light
    INTERFACE_ID = 0
    
    def initialize device_handle, recipe, plugins
      @handle = device_handle
      begin
        @handle.usb_detach_kernel_driver_np(INTERFACE_ID, INTERFACE_ID)
      rescue Errno::ENODATA => e
        # Already detached
      rescue Errno::ENOSYS => e
        # usb_detach_kernel_driver_np not implemented by libusb-compat
      end
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
