# encoding: utf-8

module ICU

=begin rdoc

== Creating Tournaments

ICU::RatedTournament object are created directly.

  t = ICU::RatedTournament.new

They have two optional parameters. One is called _desc_ (short for description) the value of which can be
any object but will, if utilized, typically be the name of the tournament as a string.

  t = ICU::RatedTournament.new(:desc => "Irish Championships 2010")
  puts t.desc                         # "Irish Championships 2010"

The other optional parameter is _start_ for the start date. A Date object or a string that can be
parsed as a string can be used to set it. The European convention is preferred for dates like
"03/06/2013" (3rd of June, not 6th of March). Attempting to set an invalid date will raise an
exception.

  t = ICU::RatedTournament.new(:start => "01/07/2010")
  puts t.start.class                  # Date
  puts t.start.to_s                   # "2010-07-01"

== Rating Tournaments

To rate a tournament, first add the players (see ICU::RatedPlayer for details):

  t.add_player(1, :rating => 2534, :kfactor => 16)
  # ...

Then add the results (see ICU::RatedResult for details):

  t.add_result(1, 1, 2, 'W')
  # ...

Then rate the tournament by calling the <em>rate!</em> method:

  t.rate!

Now the results of the rating calculations can be retrieved from the players in the tournement
or their results. For example, player 1's new rating would be:

  t.player(1).new_rating

See ICU::RatedPlayer and ICU::RatedResult for more details.

== Error Handling

Some of the above methods have the potential to raise RuntimeError exceptions.
In the case of _add_player_ and _add_result_, the use of invalid arguments
would cause such an error. Theoretically, the <em>rate!</em> method could also throw an
exception if the iterative algorithm it uses to estimate performance ratings
of unrated players failed to converge. However, practical experience has shown that
this is highly unlikely.

Since exception throwing is how errors are signalled, you should arrange for them
to be caught and handled in some suitable place in your code.

=end

  class RatedTournament
    attr_accessor :desc
    attr_reader :start

    # Add a new player to the tournament. Returns the instance of ICU::RatedPlayer created.
    # See ICU::RatedPlayer for details.
    def add_player(num, args={})
      raise "player with number #{num} already exists" if @player[num]
      @player[num] = ICU::RatedPlayer.new(num, args)
    end

    # Add a new result to the tournament. Two instances of ICU::RatedResult are
    # created. One is added to the first player and the other to the second player.
    # The method returns _nil_. See ICU::RatedResult for details.
    def add_result(round, player, opponent, score)
      n1 = player.is_a?(ICU::RatedPlayer) ? player.num : player.to_i
      n2 = opponent.is_a?(ICU::RatedPlayer) ? opponent.num : opponent.to_i
      p1 = @player[n1] || raise("no such player number (#{n1})")
      p2 = @player[n2] || raise("no such player number (#{n2})")
      r1 = ICU::RatedResult.new(round, p2, score)
      r2 = ICU::RatedResult.new(round, p1, r1.opponents_score)
      p1.add_result(r1)
      p2.add_result(r2)
      nil
    end

    # Rate the tournament. Called after all players and results have been added.
    def rate!
      performance_ratings
      players.each { |p| p.rate! }
    end

    # Return an array of all players, in order of player number.
    def players
      @player.keys.sort.map{ |num| @player[num] }
    end

    # Return a player (ICU::RatedPlayer) given a player number (returns _nil_ if the number is invalid).
    def player(num)
      @player[num]
    end

    # Set the start date. Raises exception on error.
    def start=(date)
      @start = ICU::Util.parsedate!(date)
    end

    private

    # Create a new, empty (no players, no results) tournament.
    def initialize(opt={})
      [:desc, :start].each { |atr| self.send("#{atr}=", opt[atr]) unless opt[atr].nil? }
      @player = Hash.new
    end

    def performance_ratings
      @player.values.each { |p| p.init_performance }
      stable, count = false, 0
      while !stable && count < 30
        @player.values.each { |p| p.estimate_performance }
        stable = @player.values.inject(true) { |ok, p| p.update_performance && ok }
        count+= 1
      end
      raise "performance rating estimation did not converge" unless stable
    end
  end
end
