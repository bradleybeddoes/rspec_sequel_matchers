module RspecSequel
  module Matchers

    class ValidatePresenceMatcher < RspecSequel::Base
      def description
        desc = "validate presence of #{@attribute.inspect}"
        desc << " with #{hash_to_nice_string @options}" unless @options.empty?
        desc
      end

      def valid?(db, i, c, attribute, options)

        # check column existance
        called_count = 0
        i = i.dup
        i.stub!(:validates_presence).and_return{|*args|
          if args.shift==attribute
            if options.empty?
              called_count += 1
            else
              called_options = args.shift
              @suffix << "but called with #{hash_to_nice_string called_options} instead"
              called_count +=1 if called_options==options
            end
          end
        }
        i.valid?
        called_count==1
      end
    end

    def validate_presence(*args)
      ValidatePresenceMatcher.new(*args)
    end

  end
end