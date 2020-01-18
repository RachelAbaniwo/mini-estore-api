module RequestHelpers
  module JsonHelper
    def json
      JSON.parse(response.body)
    end
  end

  def paginator (column_count, limit, page_number)
    column_entries_left = column_count - ((page_number - 1) * limit)
    count = (column_entries_left > 0) ? column_entries_left : 0
    if count >= limit
      current_page_count = limit
    else
      current_page_count = count
    end
  end
end
