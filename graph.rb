class Graph
    attr_accessor :num_nodes, :num_edges, :node_list

    def initialize
        @num_nodes = 0
        @num_edges = 0
        @node_list = Set.new()

    end

    def add_node(s)
        node_list.include?(s) ? (puts "Cant add duplicate node") : (node_list.add(s))
    end

    def add_nodes(list)
        set = list.to_set
        valid = true
        for x in list
            valid = false if node_list.include?(x)
        end
        
        valid == true ? (node_list.merge set) : (puts "Cant add. A node already exists")
        
        
        
        
    end

    def add_edge(n1, n2)
    end

    def get_edges
    end

    def to_s
        #string of adj lists
        puts "Test"
    end

    
end