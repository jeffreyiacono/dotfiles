# IRBRC file by Iain Hecker, http://iain.nl
# put all this in your ~/.irbrc
require 'rubygems'
require 'yaml'

alias q exit

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

begin # ANSI codes
  ANSI = {}
  ANSI[:BLACK]   = "\033[0;30m"
  ANSI[:GRAY]    = "\033[1;30m"
  ANSI[:LGRAY]   = "\033[0;37m"
  ANSI[:WHITE]   = "\033[1;37m"
  ANSI[:RED]     = "\033[0;31m"
  ANSI[:LRED]    = "\033[1;31m"
  ANSI[:GREEN]   = "\033[0;32m"
  ANSI[:LGREEN]  = "\033[1;32m"
  ANSI[:BROWN]   = "\033[0;33m"
  ANSI[:YELLOW]  = "\033[1;33m"
  ANSI[:BLUE]    = "\033[0;34m"
  ANSI[:LBLUE]   = "\033[1;34m"
  ANSI[:PURPLE]  = "\033[0;35m"
  ANSI[:LPURPLE] = "\033[1;35m"
  ANSI[:CYAN]    = "\033[0;36m"
  ANSI[:LCYAN]   = "\033[1;36m"

  ANSI[:BACKBLACK]  = "\033[40m"
  ANSI[:BACKRED]    = "\033[41m"
  ANSI[:BACKGREEN]  = "\033[42m"
  ANSI[:BACKYELLOW] = "\033[43m"
  ANSI[:BACKBLUE]   = "\033[44m"
  ANSI[:BACKPURPLE] = "\033[45m"
  ANSI[:BACKCYAN]   = "\033[46m"
  ANSI[:BACKGRAY]   = "\033[47m"

  ANSI[:RESET]      = "\033[0m"
  ANSI[:BOLD]       = "\033[1m"
  ANSI[:UNDERSCORE] = "\033[4m"
  ANSI[:BLINK]      = "\033[5m"
  ANSI[:REVERSE]    = "\033[7m"
  ANSI[:CONCEALED]  = "\033[8m"
end

begin # Custom Prompt
  if defined?(Rails) && Rails.respond_to?(:env)
    name = "rails: #{Rails.env}"
    colors = ANSI[:BLUE] + ANSI[:BOLD] + ANSI[:UNDERSCORE]
  else
    name = "ruby"
    colors = ANSI[:BLUE] + ANSI[:BOLD] + ANSI[:UNDERSCORE]
  end

  # :XMP
  IRB.conf[:PROMPT][:XMP][:RETURN] = "\# => %s\n"
  IRB.conf[:PROMPT][:XMP][:PROMPT_I] = ""
  
  # :SD
  IRB.conf[:PROMPT][:SD] = {
    :PROMPT_I => "#{colors}#{name}#{ANSI[:RESET]}\n" \
    + ">> ", # normal prompt
    :PROMPT_S => "%l> ",  # string continuation
    :PROMPT_C => " > ",   # code continuation
    :PROMPT_N => " > ",   # code continuation too?
    :RETURN   => "#{ANSI[:BOLD]}# => %s  #{ANSI[:RESET]}\n\n",  # return value
    :AUTO_INDENT => true
  }
  
  # :SIMPLE, :DEFAULT, :XMP. :SD
  IRB.conf[:PROMPT_MODE] = :SD
end

# Loading extensions of the console. This is wrapped
# because some might not be included in your Gemfile
# and errors will be raised
def extend_console(name, care = true, required = true)
  if care
    require name if required
    yield if block_given?
    $console_extensions << "#{ANSI[:GREEN]}#{name}#{ANSI[:RESET]}"
  else
    $console_extensions << "#{ANSI[:GRAY]}#{name}#{ANSI[:RESET]}"
  end
rescue LoadError
  $console_extensions << "#{ANSI[:RED]}#{name}#{ANSI[:RESET]}"
end
$console_extensions = []

# Wirble is a gem that handles coloring the IRB
# output and history
extend_console 'wirble' do
  Wirble.init
  Wirble.colorize
end

# Hirb makes tables easy.
# extend_console 'hirb' do
#   Hirb.enable
#   extend Hirb::Console
# end

# awesome_print is prints prettier than pretty_print
extend_console 'ap' do
  alias pp ap
end

# When you're using Rails 2 console, show queries in the console
extend_console 'rails2', (ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')), false do
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

# When you're using Rails 3 console, show queries in the console
extend_console 'rails3', defined?(ActiveSupport::Notifications), false do
  $odd_or_even_queries = false
  ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
    $odd_or_even_queries = !$odd_or_even_queries
    color = $odd_or_even_queries ? ANSI[:CYAN] : ANSI[:MAGENTA]
    event = ActiveSupport::Notifications::Event.new(*args)
    time  = "%.1fms" % event.duration
    name  = event.payload[:name]
    sql   = event.payload[:sql].gsub("\n", " ").squeeze(" ")
    puts "  #{ANSI[:UNDERLINE]}#{color}#{name} (#{time})#{ANSI[:RESET]}  #{sql}"
  end
end

# Add a method pm that shows every method on an object
# Pass a regex to filter these
extend_console 'pm', true, false do
  def pm(obj, *options) # Print methods
    methods = obj.methods
    methods -= Object.methods unless options.include? :more
    filter  = options.select {|opt| opt.kind_of? Regexp}.first
    methods = methods.select {|name| name =~ filter} if filter

    data = methods.sort.collect do |name|
      method = obj.method(name)
      if method.arity == 0
        args = "()"
      elsif method.arity > 0
        n = method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")})"
      elsif method.arity < 0
        n = -method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")}, ...)"
      end
      klass = $1 if method.inspect =~ /Method: (.*?)#/
      [name.to_s, args, klass]
    end
    max_name = data.collect {|item| item[0].size}.max
    max_args = data.collect {|item| item[1].size}.max
    data.each do |item| 
      print " #{ANSI[:YELLOW]}#{item[0].to_s.rjust(max_name)}#{ANSI[:RESET]}"
      print "#{ANSI[:BLUE]}#{item[1].ljust(max_args)}#{ANSI[:RESET]}"
      print "   #{ANSI[:GRAY]}#{item[2]}#{ANSI[:RESET]}\n"
    end
    data.size
  end
end

extend_console 'interactive_editor' do
  # no configuration needed
end

# Show results of all extension-loading
puts "#{ANSI[:GRAY]}~> Console extensions:#{ANSI[:RESET]} #{$console_extensions.join(' ')}#{ANSI[:RESET]}"
