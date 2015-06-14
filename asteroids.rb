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
    @abullets = []
    @bull_vel_x = 0.0
    @bull_vel_y = 0.0
    @lives = 3
    @score = 0
    @level = 1
    @flame = Ray::Polygon.new
  #  @flame.pos = [400,290]
    @flame.add_point([-4, 10])
    @flame.add_point([0, 20])
    @flame.add_point([-4, 10])
    @flame.filled = true

    @ast_vel= [rand(-3...3),rand(-3...3)]
    @al_vel = [rand(-3...3),rand(-3...3)]
    @aliens=[]
    @asteroids = 3.times.map do
      a = Ray::Polygon.rectangle([0, 0, 50, 50], Ray::Color.white)
      a.pos = [rand(600..800), rand(0..600)]
      a.filled = false
      a.outlined = true
      a.outline = Ray::Color.white
      a
    end
    @asteroids += 3.times.map do
      a = Ray::Polygon.rectangle([0, 0, 50, 50], Ray::Color.white)
      a.pos = [rand(0..300), rand(0..600)]
      a.filled = false
      a.outlined = true
      a.outline = Ray::Color.white
      a
    end

    always do
      puts @flame[1].pos
      puts @ship[1].pos
      puts ""
      if holding? key(:up)
        @vel_x += Math::sin(@ship.angle / (180 / Math::PI)) * 0.5
        @vel_y -= Math::cos(@ship.angle / (180 / Math::PI)) * 0.5
        if @flame[1].pos.y < @flame[0].pos.y+20
          @flame[1].pos += [0,0.3]
        end
      end
      if holding? key(:left)
        @ship.angle -= 4.5
      end
      if holding? key(:right)
        @ship.angle += 4.5
      end
      @ship.pos += [@vel_x, @vel_y]

      @flame.pos = @ship.pos
      @flame.angle = @ship.angle

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
      if holding? key(:space)
        if rand(5) == 1
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
      end
      if rand(200)==100
        @ast_vel = [rand(-5...5), rand(-5...5)]
      end
      if rand(100)==50
        @al_vel = [rand(-5...5), rand(-5...5)]
      end
      if @asteroids.empty? && @aliens.empty?
        @level += 1
        @aliens = @level.times.map do
          a =  Ray::Polygon.circle([0, 0], 10, Ray::Color.red)
          a.pos = [rand(0..800), rand(0..600)]
          a.filled = false
          a.outlined = true
          a.outline = Ray::Color.red
          a
        end
      end
      @asteroids.each do |a|
        a.pos += @ast_vel
        if a.pos.x > 800
          a.pos -= [800, 0]
        elsif a.pos.x < 0
          a.pos += [800, 0]
        elsif a.pos.y < 0
          a.pos += [0, 600]
        elsif a.pos.y > 600
          a.pos -= [0, 600]
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
        @asteroids.each do |a|
          if [b.pos.x, b.pos.y, 2, 2].to_rect.collide?([a.pos.x, a.pos.y, 50, 50])
            @bullets.delete(b)
            @score += 100
            if a.scale == [0.6, 0.6]
              @asteroids.delete(a)
            else
              a.scale = [0.6, 0.6]
            end
          end
        end
        @aliens.each do |a|
          if [b.pos.x, b.pos.y, 2, 2].to_rect.collide?([a.pos.x, a.pos.y, 20, 20])
            @bullets.delete(b)
            @score += 400
            @aliens.delete(a)
          end
        end
        #elsif condition

        b.pos += [@bull_vel_x, @bull_vel_y]
        b
      end
      @asteroids.each do |a|
        if [@ship.pos.x, @ship.pos.y, 16, 20].to_rect.collide?([a.pos.x, a.pos.y, 50, 50])
          @lives -= 1
          @asteroids.delete(a)
        end
      end
      @aliens.each do |al|
        if al.pos.x > 800
          al.pos -= [800, 0]
        elsif al.pos.x < 0
          al.pos += [800, 0]
        elsif al.pos.y < 0
          al.pos += [0, 600]
        elsif al.pos.y > 600
          al.pos -= [0, 600]
        end
        al.pos += @al_vel
        al.angle = @ship.angle + 180
        if rand(30) == 15
          @abullets += 1.times.map do
            b = Ray::Polygon.rectangle([0,0,2,2], Ray::Color.red)
            b.pos = [al.pos.x, al.pos.y]
            @abull_vel_x = 0.0
            @abull_vel_y = 0.0
            @abull_vel_x += Math::sin(al.angle / (180 / Math::PI)) * 10 * rand(0.5...1.5)
            @abull_vel_y -= Math::cos(al.angle / (180 / Math::PI)) * 10 * rand(0.5...1.5)
            b
          end
        end
      end
      @abullets.each do |ab|
        if ab.pos.x > 800
          @abullets.delete(ab)
        elsif ab.pos.x < 0
          @abullets.delete(ab)
        elsif ab.pos.y < 0
          @abullets.delete(ab)
        elsif ab.pos.y > 600
          @abullets.delete(ab)
        end
          if [@ship.pos.x, @ship.pos.y, 16, 20].to_rect.collide?([ab.pos.x, ab.pos.y, 2, 2])
            @abullets.delete(ab)
            @lives -= 1
          end
        #elsif condition

        ab.pos += [@abull_vel_x, @abull_vel_y]
        ab
      end
      if @flame[1].pos.y > @flame[0].pos.y
        @flame[1].pos -= [0, 0.1]
      end
    end
    render do |win|
    #  if @game_over
        #win.draw text("YOU LOST", :at => [180,180], :size => 60)
      if @lives <= 0
        win.draw text("YOU LOST", :at => [180,180], :size => 60)
        win.draw text("Score:" + @score.to_s, :at => [0,0], :size => 20)
      else
        win.draw @ship
        win.draw text("Lives:" + @lives.to_s, :at => [0,0], :size => 20)
        win.draw text("Score:" + @score.to_s, :at => [100,0], :size => 20)
        win.draw @flame
        @bullets.each do |b|
          win.draw b
        end
        @asteroids.each do |a|
          win.draw a
        end
        @aliens.each do |al|
          win.draw al
        end
        @abullets.each do |ab|
          win.draw ab
        end
      end
    end
  end
  scenes << :square
end


=begin

Can't get flame to work???????????????????????

add alien movment and shooting

add collison detection with asteroids

start game where you have to shoot down rockets


Tommorow:
Finihs Missle game
outline snake game
breakout game
=end
