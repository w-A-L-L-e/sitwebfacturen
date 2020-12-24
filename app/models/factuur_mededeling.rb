
class FactuurMededeling
  def initialize( nummer )
    @fac_id = nummer.to_i
  end

  def nummer
    @fac_id
  end         


  def mededeling
    #padding zodat we 10 cijfers hebben, padding rechts
    gmd = @fac_id.to_s.ljust( 10, '0' )

    #bereken de checksum en pad met 0'en links (2 cijfers)
    check = calcCheck.to_s.rjust(2, '0')
    gmd="+++ "+gmd+check+" +++"
    
    #voeg de twee / toe
    gmd.insert( 7, '/' )
    gmd.insert( 12, '/' )
  end

  def calcCheck
    crc = @fac_id - ( 97 * ( @fac_id / 97 ) )
    crc = 97 if crc == 0
    crc
  end

  def parseMededeling( s )
    @fact_id = s.delete('+').delete('/')[0..9].to_i
  end


end


