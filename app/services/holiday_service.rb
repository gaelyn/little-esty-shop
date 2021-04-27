class HolidayService
  def self.get_holidays
    resp = conn.get('/Api/v2/NextPublicHolidays/US')
    json = JSON.parse(resp.body, symbolize_names: true)

    json.map do |holiday|
      holiday
    end
  end

  def self.conn
    Faraday.new(
      url: 'https://date.nager.at'
    )
  end
end
