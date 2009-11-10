class Normalizer
  
  class << self
    def find_min_and_max(data, options={})
      @data = data
      @std = options[:std] || 0
      @cat_data = Array.new(@data[0].size) { Array.new }
      
      # Along with finding max and min this also fills @cat_data like so:
      # [[1,2,3], [1,2,3]] turns into [[1,1], [2,2], [3,3]] so we can calculate
      @max, @min = find_max, find_min
      
      unless @std > 0
        [@min, @max]
      else
        mean = find_mean
        std = calculate_std(mean)
        
        @max.each_with_index do |n, i|
          @max[i] = n + (std[i] * @std)
        end
        
        @min.each_with_index do |n, i|
          @min[i] = n - (std[i] * @std)
        end
        
        [@min, @max]
      end
    end
    
    private
    
    def calculate_std(mean)
      std = []
      
      @cat_data.each do |set|
        var = 0.0
        set.each_with_index do |n, index|
          var += ((n - mean[index]) ** 2)
        end
        std << Math.sqrt(var)
      end
      
      std
    end
    
    def find_mean
      mean = []
      
      @cat_data.each do |i|
        sum = i.inject(0.0) {|sum, n| sum += n}
        mean << sum / i.size
      end
      mean
    end
        
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
        @cat_data[index] << set[index]
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
    
    @breaks_boundary = normalized.any? {|x| x > 1 || x < 0}
    
    round_to_boundaries(normalized)
  end
  
  def breaks_boundary?
    @breaks_boundary
  end
      
  private
  
  # Data shouldn't go over/under the boundary
  def round_to_boundaries(normalized_data)
    normalized_data.map do |x|
      if x > 1
        1
      elsif x < 0
        0
      else
        x
      end
    end
  end
    
  def calculate_ranges
    range = []
    @max.each_with_index do |n, index|
      range << n - @min[index]
    end
    range
  end
    
end