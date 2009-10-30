class Normalizer
  
  class << self
    def find_max_and_min(data, options={})
      @data = data
      @std = options[:std] || 0
      @max, @min = find_max, find_min
      
      unless @std > 0
        [@min, @max]
      end
    end
    
    private
        
    def find_max
      @max = []

      @data[0].each_index do |i|
        @max << find_max_in_set(i)
      end

      @max
    end
    
    def find_min
      @min = []

      @data[0].each_index do |i|
        @min << find_min_in_set(i)
      end

      @min
    end
    
    def find_max_in_set(index)
      max = 0.0
      @data.each do |set|
        max = set[index] > max ? set[index] : max
      end
      max
    end
    
    def find_min_in_set(index)
      min = @max[index]
      @data.each do |set|
        min = set[index] < min ? set[index] : min
      end
      min
    end

  end
  
  attr_reader :max, :min, :ranges
  
  def initialize(opts={})
    @max = opts[:max].map {|x| x.to_f}
    @min = opts[:min].map {|x| x.to_f}
    @ranges = calculate_ranges
  end
    
  def normalize(data)
    normalized = Array.new(data.size)

    data.each_with_index do |n, index|
      normalized[index] = (n.to_f - @min[index]) / @ranges[index]
    end
    
    normalized
  end
      
  private
    
  def calculate_ranges
    range = []
    @max.each_with_index do |n, index|
      range << n - @min[index]
    end
    range
  end
    
end