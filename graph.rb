class Graph
    attr_accessor :num_nodes, :num_edges, :node_set, :adjmap
INC NUM OF NODES AND EDGES
    def initialize
        @num_nodes = 0
        @num_edges = 0
        @node_set = Set.new()
        @adjmap = {}

    end

    def add_node(s)
        node_set.include?(s) ? (puts "Cant add duplicate node") : (node_set.add(s))
    end

    def add_nodes(list)
        set = list.to_set
        valid = true
        for x in list
            valid = false if node_set.include?(x)
        end
        
        valid == true ? (node_set.merge set) : (puts "Cant add. A node already exists")
         
    end

    def get_nodes
        node_set.to_a
    end

    
    def add_edge(n1, n2)
        adjmap[n1] = Array.new
        adjmap[n2] = Array.new
        
        adjmap[n1] << n2
        adjmap[n2] << n1 

    end

    def get_edges
    end


    def to_s
        #string of adj lists
        for x in adjmap
            puts x.to_s + adjmap[x].to_s 
        end    
    end

end