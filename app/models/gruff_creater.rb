require 'gruff'

class GruffCreater
  def initialize(labels: [], data: [])
    @g = Gruff::Bar.new
    @g.font = 'NotoSansJP-Regular.otf'
    @g.theme_pastel

    label_hash = {}
    labels.each_with_index do |l, i|
      label_hash[i] = l
    end

    @label_hash = label_hash
    @data       = data

    if data.max < 10
      @g.maximum_value = 10
    end
  end

  def create
    # @g.title = 'Wow!  Look at this!'
    @g.labels = @label_hash
    @g.data(:読んだ本, @data)
    @g.hide_legend = true
    id = SecureRandom.alphanumeric
    @g.write("public/uploads/img/#{id}.png")
    "/uploads/img/#{id}.png"
  end
end
