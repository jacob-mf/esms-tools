#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# @title esms_tools module 
# A module to provide extra tool to ESMS text football manager 
# Available tools:
# age_check: Check if teamsheets meet the age requirements (1 playerU21 on line-up another on the bench) ; age limit also can be selected (default 21)
# important text files in "ISO-8859-1" or "UTF-8" no BOM encoding

#Gem name 	Require statement 	Main class or module
#ruby_parser 	require 'ruby_parser' 	RubyParser
# esms_tools        require 'esms_tools'        EsmsTools
# more info ESMS = Electronic Soccer Management Simulator https://github.com/eliben/esms
# @version 0.3.3
# @author Luis Jacob Mariscal Fernández

module EsmsTools

# @param age_check [|String|Integer] check teamsheet file if meet age limit requirements
# @return [TrueClass] boolean to answer if fulfill the requirements
# @raise Wrong entries 
# @advice good to use checked roster and sheet files with the TeamSheet Checker tool
def self.age_check(file = nil, limit = 21) 
 check_age_limit(limit) if limit != 21
 file = ask_filename if file.nil?
 roster = file + '.txt'
 sheet = file + 'sht.txt'
 check_file_exist sheet
 check_file_exist roster
 sheet_content = File.read(sheet)
 roster_content = File.read(roster)
 unless sheet_content.valid_encoding? and roster_content.valid_encoding?
  content = [] << sheet_content << roster_content
  content[0] = sheet_content
  content[1] = roster_content
  content = fix_encoding(content) 
  #p content
  sheet_content = content[0]
  roster_content = content[1]
 end
 cond_lineup = false
 cond_bench = false
 cond_cont_total = 0
 cond_cont_lineup = 0
 cond_cont_bench = 0
 lineup_cont = 0
 bench_cont = 0
 sheet_content.each_line { |line| 
   if /^(GK|DF|DM|MF|AM|FW)/.match(line) # player detected
    lineup_cont += 1 if lineup_cont < 11
    bench_cont += 1 if (lineup_cont == 11) and (bench_cont < 5)
    footballer = line[3..-3] # current footballer
    #p footballer.valid_encoding?
    #footballer = footballer.force_encoding("ISO-8859-15") #('UTF-8') # scrub from 2.1
    #p footballer.valid_encoding?
    #roster_content = roster_content.force_encoding("ISO-8859-15") #.valid_encoding? # utf-8 wrong iso good
    m = /#{footballer}\s+\d+/.match(roster_content) #.force_encoding('UTF-8'))
    unless m  
     puts "Footballer not found in roster, check teamsheet file"
     exit  
    end  
    if  m[0][-2..-1].to_i < limit  # age condition
     cond_cont_lineup += 1 if bench_cont == 0
     cond_cont_bench += 1 if bench_cont > 0
     cond_cont_total += 1
    end
   end 
  }
  cond_lineup = true if cond_cont_lineup > 0
  cond_bench = true if cond_cont_bench > 0
  puts 'The teamsheet has ' + lineup_cont.to_s + ' footballers on the lineup.'
  puts 'The teamsheet has ' +  bench_cont.to_s + ' footballers on the bench.' 
  puts 'The teamsheet has ' + cond_cont_total.to_s + ' footballers under ' + limit.to_s + ' years old: '
  puts ' With ' + cond_cont_lineup.to_s + ' on the lineup and ' + cond_cont_bench.to_s + ' on the bench. '
 age_cond = cond_lineup and cond_bench
 puts ' '
 puts 'So the age limit condition is accomplished.' if age_cond
 puts "So the age limit condition is not fulfilled." unless age_cond
  unless age_cond
   puts 'Would you like to try to fix it? (y/n): ' 
   answer = gets.chomp
   fix_team(roster_content, sheet, limit, cond_cont_lineup, cond_cont_bench) if answer.capitalize == 'Y'
  end
 puts 'Cheers!' 
end

def fix_team (roster_content, sheet_filename, limit, lineup_ok, bench_ok)

end

def self.ask_filename
 print "Enter the teamsheet file name (excluding the sht.txt part: ) "
 file = gets.chomp
 return file
end

def self.fix_encoding(content)
 puts "Trying to fix encoding with ISO-8859-15" # we know there are problems with encoding
 content[0] = content[0].force_encoding("ISO-8859-15") 
 content[1] = content[1].force_encoding("ISO-8859-15") 
 unless content[0].valid_encoding? and content[1].valid_encoding?
  puts "Trying to fix encoding with UTF-8 no BOM"
  content[0].gsub!("/^\xEF\xBB\xBF".force_encoding("UTF-8"), '')
  content[1].gsub!("/^\xEF\xBB\xBF".force_encoding("UTF-8"), '') 
 end
 puts '** Warning ** sheet document with encoding problems 'unless content[0].valid_encoding?
 puts '** Warning ** roster document with encoding problems 'unless content[1].valid_encoding?
 return content
end

def self.check_age_limit(age)
 age = age.to_i if age.is_a? String
 raise ArgumentError,"Error, age limit entry should be a valid footballer age value (1-99) in years " unless  (age.is_a? Integer) and (99 > age) and ( age >= 1)
end

def self.check_file_exist(filename) 
 raise IOError, "Error, file #{filename} not found on the current directory " unless File.exists?(filename)
end

#age_check

age_check

end 
