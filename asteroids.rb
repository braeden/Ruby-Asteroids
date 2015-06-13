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
    @lives = 3
    @score = 0
    @asteroids = 3.times.map do
      a = Ray::Polygon.rectangle([0, 0, 50, 50], Ray::Color.white)
      a.pos = [rand(0..200), rand(0..600)]
      a.filled = false
      a.outlined = true
      a.outline = Ray::Color.white
      a
    end
    @asteroids += 3.times.map do
      a = Ray::Polygon.rectangle([0, 0, 50, 50], Ray::Color.white)
      a.pos = [rand(600..800), rand(0..600)]
      a.filled = false
      a.outlined = true
      a.outline = Ray::Color.white
      #[rand(-3...3), rand(-3...3)]

      a
    end
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
        if [b.pos.x, b.pos.y, 2, 2].to_rect.collide?([@asteroids.any?])
          puts "Works"
        end
        b
      end
      @lives -= 1 if @asteroids.any? { |a|
        [a.pos.x, a.pos.y, 50, 50].to_rect.collide?([@ship.pos.x, @ship.pos.y, 16,20])
      }
      #; @ship.pos = [400,290]; @vel_x = 0.0; @vel_y = 0.0
    end
    render do |win|
    #  if @game_over
        #win.draw text("YOU LOST", :at => [180,180], :size => 60)
      if @lives <= 0
        win.draw text("YOU LOST", :at => [180,180], :size => 60)
      else
        win.draw @ship
        win.draw text("Lives:" + @lives.to_s, :at => [0,0], :size => 20)
        win.draw text("Score:" + @score.to_s, :at => [100,0], :size => 20)
        @bullets.each do |b|
          win.draw b
        end
        @asteroids.each do |a|
          win.draw a
        end
      end
    end
  end
  scenes << :square
end
