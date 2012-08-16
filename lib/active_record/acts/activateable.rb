module ActiveRecord
  module Acts
    module Activateable
      def self.included(base)
        base.send :extend, ClassMethods
      end
      
      module ClassMethods
        def acts_as_activateable(options = {})
          configuration = { :column => "active"}
          configuration.update(options) if options.is_a?(Hash)

          class_eval <<-EOV
            include ActiveRecord::Acts::Activateable::InstanceMethods

            def acts_as_activateable_class
              ::#{self.name}
            end

            def enabled_column
              '#{configuration[:column]}'
            end
          EOV
        end
        
        # Client.enable_all!
        def enable_all!
          all.each {|object| object.send("#{enabled_column}=", true); object.save }
        end
        
        def disable_all!
          all.each {|object| object.send("#{enabled_column}=", false); object.save; }
        end
        
        def find_enabled
          _find_all_by_active_status_of(true)
        end
        
        def find_disabled
          _find_all_by_active_status_of(false)
        end
        
        private 
        
        def _find_all_by_active_status_of(status)
          all(:conditions => { enabled_column => status })
        end
        
      end
      
      module InstanceMethods
        def enable
          # send(:active, false)
          puts "@configuration: #{@configuration}"
          puts "enabled_column: #{enabled_column}"
          self.send("#{enabled_column}=", true); save
        end
        
        def disable
          # send(:active, true)
          self.send("#{enabled_column}=", false); save
        end
        
        def enabled?
          self.send(enabled_column)
        end
        
        def disabled?
          !enabled?
        end
      end
    end
  end
end