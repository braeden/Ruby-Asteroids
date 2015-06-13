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
        @ship.pos -= [800, 0]
        #puts "tut"
      elsif @ship.pos.x < 0
        @ship.pos += [800, 0]
      elsif @ship.pos.y < 0
        @ship.pos += [0, 600]
      elsif @ship.pos.y > 600
        @ship.pos -= [0, 600]
      end
    #  if holding?(:up)
        #sangle = @ship.angle
        #puts @ship.angle
=begin
        ss = sangle/45

        if ss >= 0 && ss < 1
          xvel = ss
          @ship_vel = [xvel, -1]
        elsif ss >= 1 && ss < 2
          xvel = ss/2
          @ship_vel = [xvel, -1]
        elsif ss >= 2 && ss < 3
          xvel = ss/3
          @ship_vel = [xvel, 1]
        elsif ss >= 3 && ss < 4
          xvel = ss/4
          @ship_vel = [xvel, 1]
        else

      #end

      @ship_angle += 2 if holding?(:right)
      @ship_angle -= 2 if holding?(:left)
      @ship.angle = @ship_angle
      @ship.pos += @ship_vel
      on :key_press, key(:space) do
        @ship.angle
      end
=end
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
