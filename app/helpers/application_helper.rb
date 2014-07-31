module ApplicationHelper

  def header_title(title)
    if (title)
      return title
    end

    return "&nbsp;"
  end

  def full_title(title)
    t = "MLS Almanac"
    if (title)
      return "#{t} | #{title}"
    end

    return t
  end

  # Add style to winner, loser, and scores
  # Return a hash of ouput formats
  def parse_game(game)
    g = {}

    if (game.score1 and (game.score1 > game.score2))
      g[:team1] = link_to(content_tag(:span, game.team1.title, :class => "winner"), 
                          team_path(event_key: @event.key,
                          team_key: game.team1.key))
      g[:team2] = link_to(content_tag(:span, game.team2.title, :class => "loser"), 
                          team_path(event_key: @event.key,
                          team_key: game.team2.key))
      g[:winner] = g[:team1]
      g[:loser] = g[:team2]
    elsif (game.score1 and (game.score2 > game.score1))
      g[:team1] = link_to(content_tag(:span, game.team1.title, :class => "loser"),
                          team_path(event_key: @event.key,
                          team_key: game.team1.key))
      g[:team2] = link_to(content_tag(:span, game.team2.title, :class => "winner"), 
                          team_path(event_key: @event.key,
                          team_key: game.team2.key))
      g[:winner] = g[:team2]
      g[:loser] = g[:team1]
    else
      g[:team1] = link_to(content_tag(:span, game.team1.title, :class => "draw"),
                          team_path(event_key: @event.key,
                          team_key: game.team1.key))
      g[:team2] = link_to(content_tag(:span, game.team2.title, :class => "draw"), 
                          team_path(event_key: @event.key,
                          team_key: game.team2.key))
    end

    return g
  end

  # table is a hash
  #   table[:class] -- class for table
  #   table[:style] -- string of style info
  #   table[:headings] -- list of th entries
  #     heading[:content] -- html content
  #     heading[:style] -- string of style info
  #     heading[:class] -- string of classes
  #     heading[:colspan] -- Number of columns a header can span
  #   table[:rows] -- list of rows
  #     row - list of td entries (same as th)
  def table_helper(table)
    # table tag
    table_str = "<table"
    table_str += " class=\"#{table[:class]}\"" if (table[:class])
    table_str += " style=\"#{table[:style]}\"" if (table[:style])
    table_str += ">"

    # headings
    if table[:headings]
      table_str += '<tr>'
      table[:headings].each do |heading|
        table_str += '<th'
        table_str += " class=\"#{heading[:class]}\"" if (heading[:class])
        table_str += " style=\"#{heading[:style]}\"" if (heading[:style])
        table_str += " colspan=\"#{heading[:colspan]}\"" if (heading[:colspan])
        table_str += '>'
        table_str += heading[:content] if (heading[:content])
        table_str += '</th>'
      end
      table_str += '</tr>'
    end

    # rows
    if table[:rows]
      table[:rows].each_with_index do |row, i|
        # If we want to make each row a checkbox
        table_str += '<tr'
        table_str += " class=\"alternate_row\"" if (i%2 == 1)
        table_str += '>'
  
        # columns
        #table_str += "<label>"
        row.each do |column|
          class_s = ""
          class_s = column[:style] if (column[:style])
          table_str += '<td'
          table_str += " class=\"#{class_s}\"" if (class_s != "")
          table_str += " style=\"#{column[:style]}\"" if (column[:style])
          table_str += '>'
          table_str += "%s" % [column[:content]] if (column[:content])
          table_str += '</td>'
        end # col


        #table_str += "</label>"
        table_str += '</tr>'
      end # each row
    end # rows

    # end table tag
    table_str += "</table>"

    render inline: table_str
    #return table_str
  end
end
