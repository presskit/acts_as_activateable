require "acts_as_activateable/version"

module ActsAsActivateable
  extend ActiveSupport::Concern

  module ClassMethods
    # Makes a model searchable.
    # Takes a list of fields to use to create the index. It also take an option (:check_for_changes,
    # which defaults to true) to tell the engine wether it should check if the value of a given
    # instance has changed before it actually updates the associated fulltext row.
    # If option :parent_id is not nulled, it is used as the field to be used as the parent of the record,
    # which is useful if you want to limit your queries to a scope.
    # If option :conditions is given, it should be a string containing a ruby expression that 
    # equates to true or nil/false. Records are tested with this condition and only those that return true
    # add/update the FullTextRow. A record returning false that is already in FullTextRow is removed.
    #
    def acts_as_activateable(options = {})
      configuration = { :column => "active"}
      configuration.update(options) if options.is_a?(Hash)
      class_eval <<-EOV

        def acts_as_activateable_class
          ::#{self.name}
        end

        def enabled_column
          '#{configuration[:column]}'
        end
      EOV

			extend  ActsAsActivateableClassMethods
	    include ActsAsActivateableInstanceMethods
		end
	end
  
	module ActsAsActivateableClassMethods
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
  
  def self.included(receiver)
    receiver.extend(ClassMethods)
  end
  
  module ActsAsActivateableInstanceMethods
    def enable
      # send(:active, false)
      # puts "@configuration: #{@configuration}"
      # puts "enabled_column: #{enabled_column}"
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

ActiveRecord::Base.send :include, ActsAsActivateable