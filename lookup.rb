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

# ..
# ..
# Step 1: Filter  the comments (lines starting with #), and empty lines from the zone file.
def parse_dns(dns_dow_data)
  dns_record_data = dns_dow_data.select { |line| line[0] != "#" && line[0] != "\n"}
end
#
# Step 2: Iterate over each line, split it into an array with 3 columns using the .split method,
#         and build a hash which represents dns_records.

def split_and_strip(dns_records_data)
  dns_records_data.each_with_index{ |line, index|
    line_split= line.split(", ")
    line_split[2] = line_split[2].strip # to remove newline
    dns_records_data[index] = line_split
  }
  dns_records_data
end

def resolve(dns_records_data, lookup_chain_data, domain_data)
  #dns_hash = {}
  #dns_records_data.each { |line|
  #  (dns_hash[line[0]] ||= []) << [line[1], line[2]]
  #}
  #puts dns_hash

  current_domain = lookup_chain_data.last()
  dns_records_data.each { |x|
    if x[0]=="A" and x[1]==current_domain
      lookup_chain_data.push(x[2])
      return lookup_chain_data
    end
    if x[0]=="CNAME" and x[1]==current_domain
      lookup_chain_data.push(x[2])
      lookup_chain_data = resolve(dns_records_data, lookup_chain_data, domain_data)
      return lookup_chain_data
    end
  }
  err_message = "Error: record not found for #{lookup_chain_data[0]}"
  lookup_chain_data.pop
  lookup_chain_data.push(err_message)
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.

dns_records = parse_dns(dns_raw)
dns_records = split_and_strip(dns_records)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
