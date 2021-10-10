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
           
end

    
    

    

        
 


class Graph
include Victor

   
    
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
            #can I add the edges as integers?
            sn1 = n1.to_s
            sn2 = n2.to_s
            sn1[0] = ''
            sn2[0] = ''
            s1 = sn1.to_i
            s2 = sn2.to_i
        
            adjmap[n1] << n2
            adjmap[n2] << n1
            @num_edges += 1 
            edge_list << [s1,s2]
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


    def drawnodes(frame, n, center, radius, map)
        n.times do |i|
            x = center[0] + radius * Math.cos(2*Math::PI * i / n)
            y = center[1] + radius * Math.sin(2*Math::PI * i / n)
            
            frame.rect x: x, y: y, width: 10, height: 10,fill: '#f99'
            map[i] = [x,y] 
        end
        map
    end
    
    
    
    
    def drawedge(frame,map,n1,n2)
        style = {
        stroke: "black",
        stroke_width: 2
    }
        x1,y1 = map[n1][0], map[n1][1]
        x2,y2 = map[n2][0], map[n2][1]
      
        frame.line x1: x1, y1: y1, x2: x2, y2: y2, style: style
    
    end


    def render(filename,center,radius)
        
        num = @num_nodes
        
        frame = SVG.new
            
                frame.rect x: 0, y: 0, width: 800, height: 800,fill: '#ccc'
            
       
        

                map = self.drawnodes(frame,num,center,radius,{})
            
            for edge in edge_list
                n1 = edge[0]
                n2 = edge[1]
                self.drawedge(frame,map,n1,n2)
            end
        
        frame.save(filename)

    end

   

end
