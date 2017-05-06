require 'ncurses'

bg = Ncurses::COLOR_BLACK

def color_map(s)
  {
    "000" => 0,
    "100" => 1,
    "010" => 2,
    "001" => 3,
    "110" => 4,
    "011" => 5,
    "101" => 6,
    "111" => 7
  }[s]
end

def get_color(r, g, b)
  return Ncurses::COLOR_PAIR(color_map("#{r > 0 ? 1 : 0}#{g > 0 ? 1: 0}#{b > 0 ? 1 : 0}"))
end

def set_pixel(x, y, r, g, b)
  Ncurses::attrset(get_color(r, g, b))
  Ncurses::mvaddstr(y, x, " ")
end

def pixelx(i)
  i % 12
end

def pixely(i)
  (i - (i % 12)) / 12
end

def draw_pixel(buf)
  if buf.map(&:nil?).inject(false) { |n,p| n || p }
    puts "Not enough bytes"
  else
    set_pixel(pixelx(buf[0]), pixely(buf[0]), buf[1], buf[2], buf[3])
  end
  buf.clear
end

def draw_screen()
#  puts "Draw Screen!"
end

def process_byte(io, buf)
  byte = io.getbyte
  case byte
    when 0xFF then draw_pixel(buf)
    when 0xFE then draw_screen()
    else
      buf.push(byte)
  end
end

begin
  Ncurses::initscr()
  Ncurses::noecho()
  Ncurses::cbreak()
  Ncurses::nodelay(Ncurses::stdscr, TRUE)
  Ncurses::curs_set(0)

  if !(Ncurses::has_colors?())
    raise "Colours no available :("
  end

  if (Ncurses.COLS < 12) or (Ncurses.LINES < 14)
    raise "Screen too small!"
  end

  Ncurses::start_color()
  Ncurses::init_pair(0, Ncurses::COLOR_BLACK, bg)
  Ncurses::init_pair(1, Ncurses::COLOR_RED, Ncurses::COLOR_RED)
  Ncurses::init_pair(2, Ncurses::COLOR_GREEN, Ncurses::COLOR_GREEN)
  Ncurses::init_pair(3, Ncurses::COLOR_BLUE, Ncurses::COLOR_BLUE)
  Ncurses::init_pair(4, Ncurses::COLOR_YELLOW, Ncurses::COLOR_YELLOW)
  Ncurses::init_pair(5, Ncurses::COLOR_CYAN, Ncurses::COLOR_CYAN)
  Ncurses::init_pair(6, Ncurses::COLOR_MAGENTA, Ncurses::COLOR_MAGENTA)
  Ncurses::init_pair(7, Ncurses::COLOR_WHITE, Ncurses::COLOR_WHITE)

  io = File.open("/tmp/serial.pipe", "r+")
  buf = []

  while (:restart)
    process_byte(io, buf)

    if ((ch = Ncurses::getch()) != Ncurses::ERR)
      if (ch == Ncurses::KEY_RESIZE)
        Ncurses::erase()
        window_size_changed = true
      else
        break
      end
    end
  end
ensure
  Ncurses::curs_set(1)
  Ncurses::endwin()
end

