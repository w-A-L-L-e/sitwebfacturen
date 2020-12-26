# rubocop:disable Style/FrozenStringLiteralComment

# Author: Walter Schreppers
# Description:
#   Generates gestructureerde mededeling, used by invoices
class FactuurMededeling
  def initialize(nummer)
    @fac_id = nummer.to_i
  end

  def nummer
    @fac_id
  end

  def mededeling
    # padding zodat we 10 cijfers hebben, padding rechts
    gmd = @fac_id.to_s.ljust(10, '0')

    # bereken de checksum en pad met 0'en links (2 cijfers)
    check = calc_checksum.to_s.rjust(2, '0')
    gmd = "+++ #{gmd}#{check} +++"

    # voeg de twee / toe
    gmd.insert(7, '/')
    gmd.insert(12, '/')
  end

  def calc_checksum
    crc = @fac_id - (97 * (@fac_id / 97))
    crc = 97 if crc.zero?
    crc
  end

  def parse_mededeling(mededeling_str)
    @fact_id = mededeling_str.delete('+').delete('/')[0..9].to_i
  end
end

# rubocop:enable Style/FrozenStringLiteralComment
