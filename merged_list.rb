lists = [[1,4,5],[1,3,4],[2,6]]
merged_list = []
lists.each do |list|
  merged_list += list
end
puts merged_list.sort