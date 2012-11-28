output = File.open("output.txt", "w")
IO.readlines("input.txt").each do |line|
  output.puts( line.split.map { |x| x.to_i }.reduce(:+) )
end
