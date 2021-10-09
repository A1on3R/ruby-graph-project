require 'victor'
include Victor



def drawnodes(n, center, radius)
    n.times do |i|
        x = center[0] + radius * Math.cos(2*Math::PI * i / n)
        y = center[1] + radius * Math.sin(2*Math::PI * i / n)
        
        rect x: x, y: y, width: 10, height: 10,fill: '#f99' 
    end
end


#-------------------------------------------------------

svg = SVG.new do
    rect x: 0, y: 0, width: 800, height: 800,fill: '#ccc'
    drawnodes(18,[400,400],200)
end



#result = svg.render

#result = svg.to_s




svg.save '01_hello_world'