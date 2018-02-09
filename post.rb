class Post

  attr_accessor :message, :id, :from, :type, :properties, :link, :shares, :likes, :comments, :created_time, :updated_time

  def initialize(h)
    h.each { |k,v| send("#{k}=", v)}
  end
end