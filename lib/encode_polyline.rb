module EncodePolyline
  def encode_signed(n)
    max_32 = ((2 ** 32) - 1)

    as_i = (n*1e5).round.abs
    #raise "#{n} too small to encode" if as_i == 0 #TODO: better solution
    return "?" if as_i == 0

    as_i = (as_i ^ max_32) + 1 if n<0 #flip us into a 32-bit two's complement, if negative.
    as_i = (as_i << 1) & max_32  #rotate left shift 1

    binary = "%032b"%(as_i)
    binary.tr!("01","10") if n<0 #re-invert if negative

    bit_chunks = binary[2,30].scan(/.{5}/).reverse
    bit_chunks.pop while bit_chunks.last == "00000" #remove empty chunks
    bit_chunks = bit_chunks.map {|x| "1"+x}
    bit_chunks.last[0]="0" #remove the leading '1' from the last chunk

    bit_chunks.map {|x| (x.to_i(2) + 63).chr}*""
  end

  def simplify_points(points,lower_tolerance,upper_tolerance)
    p2 = points.dup
    i=1
    while i<p2.length do
      diffs = [:lat,:lon].map {|m| (p2[i].send(m) - p2[i-1].send(m)).abs}
      if diffs.any? {|d| d < lower_tolerance} && !diffs.any? {|d| d > upper_tolerance}
        p2.delete_at(i)
      else
        i+=1
      end
    end
    p2
  end

  def encode_line(points)
    start = encode_signed(points.first.lat) + encode_signed(points.first.lon)
    start + points.each_cons(2).map {|p1,p2| encode_signed(p2.lat-p1.lat) + encode_signed(p2.lon-p1.lon)}.join
  end
end