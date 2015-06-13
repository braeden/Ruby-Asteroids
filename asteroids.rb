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
    @vel_x = 0.0
    @vel_y = 0.0
    @bullets = []
    @bull_vel_x = 0.0
    @bull_vel_y = 0.0
    @asteroids = 5.times.map do
      a = Ray::Polygon.rectangle([0, 0, 50, 50], Ray::Color.white)
      a.pos = [rand(0..30), rand(0..600)]
      a.filled   = false
      a.outlined = true
      a
    end
    #on :key_press, key(:q){ exit! }

    always do

      if holding? key(:up)
        @vel_x += (@ship.angle / (180 / Math::PI))
        @vel_y -= (@ship.angle / (180 / Math::PI))
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
      elsif @ship.pos.x < 0
        @ship.pos += [800, 0]
      elsif @ship.pos.y < 0
        @ship.pos += [0, 600]
      elsif @ship.pos.y > 600
        @ship.pos -= [0, 600]
      end
      on :key_press, key(:space) do
        @bullets += 1.times.map do
          b = Ray::Polygon.rectangle([0,0,2,2], Ray::Color.white)
          b.pos = [@ship.pos.x, @ship.pos.y]
          @bull_vel_x = 0.0
          @bull_vel_y = 0.0
          @bull_vel_x += Math::sin(@ship.angle / (180 / Math::PI)) * 20
          @bull_vel_y -= Math::cos(@ship.angle / (180 / Math::PI)) * 20
          b
        end
      end
      @bullets.each do |b|
        if b.pos.x > 800
          @bullets.delete(b)
        elsif b.pos.x < 0
          @bullets.delete(b)
        elsif b.pos.y < 0
          @bullets.delete(b)
        elsif b.pos.y > 600
          @bullets.delete(b)
        end
        b.pos += [@bull_vel_x, @bull_vel_y]
        b
      end
    end
    render do |win|
      win.draw @ship
      @bullets.each do |b|
        win.draw b
      end
      @asteroids.each do |a|
        win.draw a
      end
    end
  end
  scenes << :square
end
