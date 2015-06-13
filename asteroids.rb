require 'ray'
#Define Window Title
Ray.game "Asteroids", :size => [800, 600] do
  register { add_hook :quit, method(:exit!) }
  scene :square do
    #Create Ship and Define parmeters
    @ship = Ray::Polygon.new
    @ship.add_point([392,300])
    @ship.add_point([408,300])
    @ship.add_point([400,280])
    @ship.filled   = false
    @ship.outlined = true
    @ship_vel = [0,0]

    #on :key_press, key(:q){ exit! }

    always do

    end
    render do |win|
      win.draw @ship
    end
  end
  scenes << :square
end
