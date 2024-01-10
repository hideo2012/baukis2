256.times do |i|
  HashLock.create!( table: "tags", column: "value", key: sprintf( "%02x", i )  ) # 00 ~ ff
end
