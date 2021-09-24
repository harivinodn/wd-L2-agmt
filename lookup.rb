def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

# Step 1: Filter  the comments (lines starting with #), and empty lines from the zone file.
def preprocess(dns_row_data)

  #puts dns_row_data.class

  dns_records_data = dns_row_data.select { |line| line[0] != "#" && line[0] != "\n"}
  #puts dns_records_data
  #puts dns_records_data.class

  dns_records_data.each_with_index{ |line, index|
    line_split= line.split(", ")
    line_split[2] = line_split[2].strip # to remove newline
    dns_records_data[index] = line_split
  }
  dns_records_data
end

def parse_dns(dns_records_data)

  dns_hash = {}
  dns_records_data.each { |line|
    dns_hash = {line[1].to_sym => {type: line[0], target: line[2]}}
  }
  dns_hash
  puts dns_hash
end

# Step 2: Iterate over each line, split it into an array with 3 columns using the .split method,
#         and build a hash which represents dns_records.




def resolve(dns_records_data, lookup_chain_data, domain_data)
  #dns_hash = {}
  #dns_records_data.each { |line|
  #  (dns_hash[line[0]] ||= []) << [line[1], line[2]]
  #}
  #puts dns_hash

  record = dns_records[domain]
  if (!record)
    lookup_chain << "Error: Record not found for "+domain
    return
  elsif record[:type] == "CNAME"
    # ...
  elsif record[:type] == "A"
    #...
  else
    lookup_chain << "Invalid record type for "+domain
    return
  end
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = preprocess(dns_raw)
puts dns_records

dns_records = parse_dns(dns_records)
#lookup_chain = [domain]
#lookup_chain = resolve(dns_records, lookup_chain, domain)
#puts lookup_chain.join(" => ")
