require "openssl"

# Just uses OpenSSL's Big Number mod_exp to quickly raise numbers to powers under modulo
# Still not super fast, but fast enough
card_pub = 9789649               # loop = 14587082
door_pub = 3647239               # loop = 12387410

# This will find the loop number
base = OpenSSL::BN.new(7)
(1..20201227).each do |loop_number|
  if base.mod_exp(loop_number, 20201227) == door_pub
    # This will take the loop number and the public key and find the encryption key
    base = OpenSSL::BN.new(9789649)
    puts base.mod_exp(loop_number, 20201227)
    exit
  end
end
