require 'victor'

    
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
                #generate rand num between 1 and 100. the formula makes a range of valid numbers from 1 to p*100
                # if a valid number appears, create the new edge
                #The higher p is, the more valid numbers there are. 1.0 means all numbers are valid. 0.5 means half are valid. 0.0 means none are valid
                ran_num = rand(1..100)
                if 1 <= ran_num && ran_num <= (p * 100)

                    g.add_edge(("V" + i.to_s).to_sym,j)

                end
            end

            #node goes into set
            node_set << ("V" + i.to_s).to_sym
        end
            
            g
    end

    def self.dfs(graph,node)
        visited = Set.new
        
        m = graph.adjmap
       
        
        dfs_rec(node,visited,m)
        return visited

    end
    
    
    def self.dfs_rec(node,visited,adjmap)
        visited.add(node)
        for x in adjmap[node]
            if !visited.include?(x)
                
                dfs_rec(x,visited,adjmap)
            end
        end
    end
    def self.dfs_edges_rec(visited,node,parent,child)
        visited.add(node)
        for x in parent.adjmap[node]
            if !visited.include?(x)
                child.add_edge(node, x)
                dfs_edges_rec(visited,x,parent,child)
            end
        end

    end

    def self.dfs_edges(node,parent,child)
        visited = Set.new
        dfs_edges_rec(visited,node,parent,child)   
    end
    
    
    
    def self.render_graphs(filename, graphs_strokes_fills)
        #Can I assign the global frame using the first graph here?
        for graph,stroke,fill in graphs_strokes_fills
            graph.render(filename,[400,400],100,stroke,fill,false)
        end
        graphs_strokes_fills[0][0].clear_frame
    end

    def self.genSubgraph(parent, ns)
        child = Graph.new
        child.parent = parent
        o_node = ns.to_a[0]
       
        child.add_nodes(ns)
        #Without using visited, it can color all the edges from the reachable nodes
        dfs_edges(o_node,parent,child)
        child
     
    end

end


class Graph
    
    include Victor
    
    attr_accessor :num_nodes, :num_edges, :adjmap, :node_list, :edge_list, :layout, :parent, :frame
    @@frame
    @@frame = SVG.new
            
    @@frame.rect x: 0, y: 0, width: 800, height: 800,fill: '#ccc'
    def initialize
        @num_nodes = 0
        @num_edges = 0
        @node_list = Array.new
        @edge_list = Array.new
        @layout = {}
        @parent = nil 
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
           
            # s1 = self.node_to_int(n1)
            # s2 = self.node_to_int(n2)
        
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


    def drawnode(frame, x, y, node_fill)

            frame.circle cx: x, cy: y, r: 5, fill: node_fill       
    end

    def layout_circular(center, radius)

        map = {}
        (0..node_list.size - 1).each do |i|

            y = (center[1] + radius * Math.sin(2*Math::PI * i / (node_list.size))).to_f.truncate(2)
            x = (center[0] + radius * Math.cos(2*Math::PI * i / (node_list.size))).to_f.truncate(2)

            map[('V' + i.to_s).to_sym] = [x,y]
        end
        @layout = map
        
        map
    end
   
    
    def drawedge(frame,map,n1,n2,stroke="black")
        style = {
        stroke: stroke,
        stroke_width: 2
    }
        x1,y1 = map[n1][0], map[n1][1]
        x2,y2 = map[n2][0], map[n2][1]
      
        frame.line x1: x1, y1: y1, x2: x2, y2: y2, style: style
    
    end

    def render(filename,center,radius,edge_stroke="black",node_fill="blue",single=true)
        
    
        if self.parent == nil
            map = self.layout_circular(center,radius)
        else
            map = self.parent.layout
            self.layout = map
            
        end     
        
        for edge in edge_list
            n1 = edge[0]
            n2 = edge[1]
            self.drawedge(@@frame,map,n1,n2,edge_stroke)
        end

        for node in node_list
            x,y = map[node][0], map[node][1]
            self.drawnode(@@frame,x,y,node_fill)
        end
                   
        @@frame.save(filename)

        if single
            self.clear_frame
        end
        
    end
    
    def clear_frame
        @@frame = SVG.new
        @@frame.rect x: 0, y: 0, width: 800, height: 800,fill: '#ccc'
    end

   
end
