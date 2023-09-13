class Variable

end

class Hyperstring

        NEXT_TAG_REGEX = /^(.*)(#+\([^\)]*\))(.*)$/.freeze()

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
            while (match = NEXT_TAG_REGEX.match(rest))
                    items.push(match[1]) unless match[1].empty?
                    items.push(match[2]) 
                    rest = match[3]
            end
            items.push rest unless rest.empty?
            items
        end

end
