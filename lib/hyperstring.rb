class Variable

     NAME_REGEX = /^#\(([^\)]+)\)/.freeze()

     def initialize(string)
            if (match = NAME_REGEX.match(string))
                @name = match[1]       
            end
     end

     def to_s
        "#(#{@name})"
     end

     def name
        @name
     end
end

class VariableResolver
    attr_reader :type_name

    def can_handle?(variable)
       false
    end

    protected

    def initialize(type_name)
        @type_name = type_name
    end
end

class DiceResolver < VariableResolver
    attr_reader :name
    class BadHistogram < StandardError
    end
    
    DICE_RESOLVER = "DiceResolver".freeze()

    def initialize(name, histogram)
       super(DICE_RESOLVER)
       raise BadHistogram unless valid_histogram?(histogram)
       @name = name
       @histogram = histogram.dup.freeze()
       @frequency_sum = @histogram.values.sum
    end

    def can_handle?(variable)
            return @name.upcase == variable.name.upcase
    end

    def resolve(variable)
        remaining_weight = rand(@frequency_sum)

        @histogram.each do |hyperstring, weight|
           return hyperstring if remaining_weight <= 0
           remaining_weight -= weight
        end

        raise StandardError, "Shouldn't be here"
    end

    private

    def valid_histogram?(histogram)
        return false if histogram.empty?
        return false unless histogram.all? { |k,v| k.is_a?(Hyperstring) && v.is_a?(Integer) }
        return false unless histogram.all? { |k,v| v > 0 }
        return true
    end

end

class NoOpResolver < VariableResolver
   NO_OP_RESOLVER = "NoOpResolver".freeze()

   def initialize()
       super(NO_OP_RESOLVER)
   end

    def can_handle?(variable)
        true
    end

    def resolve(variable)
        return variable.to_s
    end
end

class HyperstringResolver
       class BadItem < StandardError
       end

       def initialize(variable_resolvers, last_resort_resolver)
              @variable_resolvers = Array.new(variable_resolvers) 
              @last_resort_resolver = last_resort_resolver
       end
       

       def resolve(root)
           item_stack = [root]
           output = []
           until (item_stack.empty?)
                  curr = item_stack.pop
                  
                  if curr.is_a?(Hyperstring)
                     curr.items.each do |x|
                        item_stack.push(x)
                     end
                  elsif curr.is_a?(Variable)
                     resolver = @variable_resolvers.find { |r| r.can_handle?(curr) } || last_resort_resolver
                     item_stack.push(resolver.resolve(curr))
                  elsif curr.is_a?(String)
                    output.push(curr)
                  else
                    raise BadItem, "{curr} is not an expected type"
                  end
           end
           output.reverse.join('')
       end

end

class Hyperstring
        
        STARTING_TAG = /^(#\([^\)]*\))(.*)/.freeze()
        STARTING_LITERAL = /^(.*)(#+\([^\)]*\)(.*))$/.freeze()
        
        def initialize(string)
            @items = parse(string)
        end

        def items
            @items
        end

        def to_s
            @items.map(&:to_s).join('')
        end

        private

        def parse(string)
            rest = string
            items = []
            while not rest.empty?
                    if (match = STARTING_TAG.match(rest))
                            items.push(Variable.new(match[1]))
                            rest = match[2]
                    elsif (match = STARTING_LITERAL.match(rest))
                            items.push(match[1])
                            rest = match[2]
                    else
                            items.push(rest)
                            rest = "" 
                    end
            end
            items
        end

end
