require 'ray'
#Define Window Title
Ray.game "Asteroids", :size => [800, 600] do
  register { add_hook :quit, method(:exit!) }
  scene :square do
    #Create Ship and Define parmeters
    @ship = Ray::Polygon.new
    @ship.pos = [400,290]
    @ship.add_point([-8,10])
    @ship.add_point([8,10])
    @ship.add_point([0,-10])
    @ship.filled   = false
    @ship.outlined = true
    @ship_vel = [0,0]
    @ship_angle = @ship.angle
    @vel_x = @vel_y = 0.0

    #on :key_press, key(:q){ exit! }

    always do

      if holding? key(:up)
        @vel_x += Math::sin(@ship.angle / (180 / Math::PI)) * 0.5
        @vel_y -= Math::cos(@ship.angle / (180 / Math::PI)) * 0.5
      end

      if holding? key(:left)
        @ship.angle -= 4.5
      end

      if holding? key(:right)
        @ship.angle += 4.5
      end
      @ship.pos += [@vel_x, @vel_y]

      @vel_x *= 0.97
      @vel_y *= 0.97
      #pass through screen
      if @ship.pos.x > 800
        @ship.pos -= [800, 0
      elsif @ship.pos.x < 0
        @ship.pos += [800, 0]
      elsif @ship.pos.y < 0
        @ship.pos += [0, 600]
      elsif @ship.pos.y > 600
        @ship.pos -= [0, 600]
      end
    end
    render do |win|
      win.draw @ship
    end
  end
  scenes << :square
end


=begin
Divide angle/45
if that>1 add to x thatnum and add y 1
if that < 1 make y thatnum and make x 1

=end
