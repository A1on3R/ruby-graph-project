module GraphUtils
    def self.genCompleteGraph(n, p = 1.0, node_set = Set.new)
        #Create n nodes
        g = Graph.new

        # for each node, in 0..n-1, we create an edge between that node and *every other node* in the list at that point
        (0..n-1).each do |i|
            # node = "V" + i.to_s
            g.add_node(("V" + i.to_s).to_sym) #node is added and included in g's nodelist. use the node_set for making new edges
            
            #now, connect that node to each node in the set
            node_set.each do |j|
                #can i generate rand num between 1 and 100 and multiply by p and add the edge only if that number is greater than the total non possibilities
                ran_num = rand(1..100)
                if 1 <= ran_num && ran_num <= 100 - (100 -(p * 100))

                    g.add_edge(("V" + i.to_s).to_sym,j)

                end
            end

            #node goes into set
            node_set << ("V" + i.to_s).to_sym
        end
            
            g
    end
           
end
        
 


class Graph
    
        
        
    
    
    attr_accessor :num_nodes, :num_edges, :adjmap, :node_list, :edge_list

    def initialize
        @num_nodes = 0
        @num_edges = 0
        @node_list = Array.new
        @edge_list = Array.new
        
        @adjmap = {}

    end

    def add_node(s)
        if !adjmap.has_key?(s) 
            adjmap[s] = Array.new
            node_list << s
            @num_nodes += 1

        else
            puts "Cant add duplicate node"
        end
    end

    def add_nodes(list)
        
        valid = true
        for x in list
            valid = false if adjmap.has_key?(x)
        end
        
        if valid == true  
            
            @num_nodes += list.size
            for s in list
                adjmap[s] = Array.new
                node_list << s
            end
        else
            puts "Can't add a list of nodes if it contains a node already existing"
        end
         
    end

    def get_nodes
        node_list
    end

    
    def add_edge(n1, n2)
        #nodes must be in set And edges must not exist in adjmap
        if (adjmap.has_key?(n1) && adjmap.has_key?(n2) && !edge_list.include?([n1,n2]) && n1 != n2)
        
            adjmap[n1] << n2
            adjmap[n2] << n1
            @num_edges += 1 
            edge_list << [n1,n2]
            [n1,n2]
        else
            puts "Cannot add edges when they already exist or if the nodes dont exist"
        end


    end

    def get_edges
        edge_list
    end


    def to_s
        #string of adj lists
        for x in adjmap.keys
            puts x.to_s + " ----> " + adjmap[x].to_s 
        end    
    end

   

end
