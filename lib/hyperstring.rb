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

class Hyperstring
        
        STARTING_TAG = /^(#\([^\)]*\))(.*)/.freeze()
        STARTING_LITERAL = /^(.*)(#+\([^\)]*\)(.*))$/.freeze()
        
        def initialize(string)
            @items = parse(string)
        end

        def items
            @items
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
