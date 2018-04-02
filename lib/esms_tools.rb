#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# @title Esms_Tools module 
# A module to provide extra tool to ESMS text football manager 
# Available tools:
# age_check: Check if teamsheets meet the age requirements (1 playerU21 on line-up another on the bench) ; age limit also can be selected (default 21)
# important text files in "ISO-8859-1" or "UTF-8" no BOM encoding
# age_check273 same as previus but for ESMS 2.73 version

#Gem name 	Require statement 	Main class or module
# esms_tools        require 'esms_tools'        EsmsTools
# more info ESMS = Electronic Soccer Management Simulator https://github.com/eliben/esms
# @version 0.3.4
# @author Luis Jacob Mariscal Fernández

module EsmsTools

# @param age_check273 [|String|Integer] check teamsheet file (for ESMS 2.73) if meet age limit requirements
# @return [TrueClass] boolean to answer if fulfill the requirements
# @raise Wrong entries 
# @advice good to use checked roster and sheet files with the TeamSheet Checker tool
def self.age_check273(file = nil, limit = nil) 
 file = ask_filename if file.nil?
 limit = ask_age if limit.nil? #  == 21
 limit = check_age_limit(limit) #if ! limit.nil?  # != 21
 roster = file + '.txt'
 sheet = file + 'sht.txt'
 check_file_exist sheet
 check_file_exist roster
 sheet_content = File.read(sheet)
 roster_content = File.read(roster)
 unless sheet_content.valid_encoding? && roster_content.valid_encoding?
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
   if /^(GK|DFC|DFR|DFL|DMC|DMR|DML|MFC|MFR|MFL|AMC|AMR|AML|FWR|FWL|FWC)/.match(line) # player detected
    lineup_cont += 1 if lineup_cont < 11
    bench_cont += 1 if (lineup_cont == 11) && (bench_cont < 5)
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
  #p age_cond
 age_cond = cond_lineup && cond_bench
 
 puts ' '
 puts 'So the age limit condition is accomplished.' if age_cond
 puts "So the age limit condition is not fulfilled." unless age_cond
  #unless age_cond
   #puts 'Would you like to try to fix it? (y/n): ' 
   #answer = gets.chomp
   #fix_team(roster_content, sheet, limit, cond_cont_lineup, cond_cont_bench) if answer.capitalize == 'Y'
  #end
 puts 'Cheers!' 
end

# @param age_check [|String|Integer] check teamsheet file if meet age limit requirements
# @return [TrueClass] boolean to answer if fulfill the requirements
# @raise Wrong entries 
# @advice good to use checked roster and sheet files with the TeamSheet Checker tool
def self.age_check(file = nil, limit = nil) 
 file = ask_filename if file.nil?
 limit = ask_age if limit.nil? #  == 21
 limit = check_age_limit(limit) #if ! limit.nil?  # != 21
 roster = file + '.txt'
 sheet = file + 'sht.txt'
 check_file_exist sheet
 check_file_exist roster
 sheet_content = File.read(sheet)
 roster_content = File.read(roster)
 unless sheet_content.valid_encoding? && roster_content.valid_encoding?
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
    bench_cont += 1 if (lineup_cont == 11) && (bench_cont < 5)
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
  #p age_cond
 age_cond = cond_lineup && cond_bench
 
 puts ' '
 puts 'So the age limit condition is accomplished.' if age_cond
 puts "So the age limit condition is not fulfilled." unless age_cond
  #unless age_cond
   #puts 'Would you like to try to fix it? (y/n): ' 
   #answer = gets.chomp
   #fix_team(roster_content, sheet, limit, cond_cont_lineup, cond_cont_bench) if answer.capitalize == 'Y'
  #end
 puts 'Cheers!' 
end

# @param eos_effect [|String|] a roster filename  (or ask) then create a new file original txt name + "_eos" 
# @return [TrueClass] boolean to answer if everything was fine
# @raise Wrong entries 
# @advice good to use checked roster, this is for ESMS roster version 3 or more 
def self.eos_effect(file = nil) 
 file = ask_filename if file.nil?
 roster = file + '.txt'
 check_file_exist roster
 roster_content = File.read(roster)
 unless roster_content.valid_encoding?
  content = [] << roster_content
  content[0] = roster_content
  #content = fix_encoding(content) 
  roster_content = content[0].force_encoding("ISO-8859-15")
 end
 new_roster = []
 roster_content.each_line { |line| 
   if /^(\w+\s+\d+)/.match(line) # player detected
    #footballer = line[0..13] #.gsub(' ','') # current footballer
    #p footballer
    #p footballer.valid_encoding?
    #footballer = footballer.force_encoding("ISO-8859-15") #('UTF-8') # scrub from 2.1
    #p footballer.valid_encoding?
    #roster_content = roster_content.force_encoding("ISO-8859-15") #.valid_encoding? # utf-8 wrong iso good
    #m = /#{footballer}\s+\d+/.match(line) #.force_encoding('UTF-8'))
    #age = m[0][-2..-1].to_i
    #m = /^(\w+\s+\d+)/.match(line)
    #p m  
    #age =  m[0][-2..-1].to_i   # age condition
    m1 =  /^((\w+)\s+(\d+)\s+(\w+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+)/.match(line)
    #p m1   # all
    #p m1[1]  # all
    #p m1[0] # all, 2: name , 3: age, 4: country code , 5: St, 6: Tk , 7: Ps, 8: Sh ,9: Ag , 10-13 Abs: St-Tk-Ps-Sh
    age = m1[3].to_i
    country = m1[4]
    ag = m1[9] # aggression level
    primary_skill = [ m1[5].to_i, m1[6].to_i, m1[7].to_i, m1[8].to_i ].max
    secondary_skill = ([ m1[5].to_i, m1[6].to_i, m1[7].to_i, m1[8].to_i ]-[primary_skill]).max
    #p m1[5,13]
    #p primary_skill
    #p secondary_skill
    if age >= 35 #   -300 -100 -75 -75
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[-300,-100,-75])    
    elsif age == 34 #  -175 -50 -30 -30
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[-175,-50,-30])
    elsif age == 33 #    -100 -45 -20
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[-100,-45,-20])
    elsif age == 31 #    -15 -10 -5
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[-15,-10,-5])
    elsif age == 32 #    -30 -30 -10
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[-30,-30,-10])
    elsif age == 30 #    -10 -5 -2
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[-10,-5,-2])
    elsif (age >= 27) && (age <= 29)  #    100 20 20
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[100,20,20])  
    elsif (age >= 22) && (age <= 26)  #    200 40 40
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[200,40,40])   
    elsif (age >= 20) && (age <= 21)  #    400 80 80
     sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[400,80,80]) 
    elsif age <= 19 # 800 200 200
      sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[800,200,200])  
    end
    age += 1
    new_roster = new_roster << line[0..13] + age.to_s + ' ' + country + ' ' + sol[0].to_s + ' ' + sol[1].to_s + ' ' + sol[2].to_s + ' ' + sol[3].to_s + ' '+ ag.to_s + ' ' + sol[5].to_s + ' ' + sol[6].to_s + ' ' + sol[7].to_s + ' ' + sol[8].to_s  
    # save first name + age + country, 
   else
    new_roster = new_roster << line 
   end
  }
  #p new_roster[5]
  # save new roster adjusted
  fname = file + "_new.txt"
  savefile = File.open(fname, "w")
  new_roster.each { |line| 
    savefile.puts line
  } 
  print "Success! New roster generated in file:  " + fname + "\n"
  printf " Enjoy! cheers! "
  savefile.close
end

# @param adjust_skill [Int, Int, Array, Arrray]  
# @return [Array] with adjusted skills [St, Tk, Ps,Sh, Ag, KAb, TAb, PAb, SAb]
# @advice good to use only internal, this is for ESMS roster version 3 or more 
# sample of use: sol = adjust_skill(primary_skill, secondary_skill,m1[5,13],[-175,-50,-30])
def self.adjust_skill(prim, sec, skill, bonus) # skill field 9 (here 4) is Ag, no change on it, not needed here
 sol = [] # solution to return
 aux = []
 i = 0
 #p skill
 sol[4] = skill [4] # Ag skill is just copied
 while (i <= 3) # the 4 skills, Abs points on i + 5
  if skill[i].to_i == prim # i skill is primary skill
   aux = calc_skill(skill[i], skill[i+5], bonus[0])
   sol[i] = aux[0]
   sol[i+5] = aux[1]
  elsif skill [i].to_i == sec
   aux = calc_skill(skill[i], skill[i+5], bonus[1])
   sol[i] = aux[0]
   sol[i+5] = aux[1] 
  else # third or lower class of skill (minors)
   aux = calc_skill(skill[i], skill[i+5], bonus[2])
   sol[i] = aux[0]
   sol[i+5] = aux[1] 
  end
 i += 1
 end 
 return sol
end

# @param calc_skill [Int, Int, Int]  
# @return [Array] with changed skills [Int, Int] represents [Value, Abs] of the ESMS skill
# @advice good to use only internal, this is for ESMS roster version 3 or more 
# sample of use: sol = calc_skill(tackling_skill, tk_abs_skill, 200)
def self.calc_skill(skill, abs, bonus)
 sol = [] # solution to return
 #puts  skill.to_s + ' ' + abs.to_s + ' ' + bonus.to_s
 total = abs.to_i + bonus.to_i
 sol[1] = (total).% 1000
 if total >= 1000 
  sol[0] = skill.to_i + 1 # increase main skill value, level gained
 elsif total < 0 
  sol[0] = skill.to_i - 1 # decrease main skill value, level lost
 else
  sol[0] = skill.to_i
 end
 return sol  
end
#p adjust_skill(10, 3, [1,10,3  , 2 ,34 ,357  ,96 ,349, 685 ], [-175,-50,-30])

# a new idea to explore
#def fix_team (roster_content, sheet_filename, limit, lineup_ok, bench_ok)

#end

# @param ask_filename  ; get file name string for the teamsheet
# @return [String] file name for the teamsheet
# @raise Wrong entries 
# @advice good to use checked roster and sheet files with the TeamSheet Checker tool
def self.ask_filename
 print "Enter the teamsheet file name (excluding the sht.txt part: ) "
 file = gets.chomp
 return file
end

# @param ask_age  ; get age limit number
# @return [Integer] age number for the limit
# @raise Wrong entries 
# @advice good to use checked roster and sheet files with the TeamSheet Checker tool
def self.ask_age
 puts "Enter the age limit condition (between 1-99)", "RETURN to accept default 21 years old age limit: "
 age = gets.chomp
 check_age_limit(age) unless age == ''
 age = 21 if age == '' 
 return age.to_i
end

# @param fix_encoding [Array] fix content to valid encoding 
# @return [Array] fixed content if possible
# @raise Wrong exit just inform warning messages, beware 
# @advice good to use checked roster and sheet files with the TeamSheet Checker tool, coding with ISO-885915 or UTF-8 no BOM
def self.fix_encoding(content)
 puts "Trying to fix encoding with ISO-8859-15" # we know there are problems with encoding
 content[0] = content[0].force_encoding("ISO-8859-15") 
 content[1] = content[1].force_encoding("ISO-8859-15") 
 unless content[0].valid_encoding? && content[1].valid_encoding?
  puts "Trying to fix encoding with UTF-8 no BOM"
  content[0].gsub!("/^\xEF\xBB\xBF".force_encoding("UTF-8"), '')
  content[1].gsub!("/^\xEF\xBB\xBF".force_encoding("UTF-8"), '') 
 end
 puts '** Warning ** sheet document with encoding problems 'unless content[0].valid_encoding?
 puts '** Warning ** roster document with encoding problems 'unless content[1].valid_encoding?
 return content
end

# @param check_age_limit [Integer]  ; check age limit number
# @return [Integer] age number for the limit
# @raise Wrong entries 
# @advice good to use checked roster and sheet files with the TeamSheet Checker tool
def self.check_age_limit(age)
 age = age.to_i if age.is_a? String
 raise ArgumentError,"Error, age limit entry should be a valid footballer age value (1-99) in years " unless  (age.is_a? Integer) && (99 > age) && ( age >= 1)
 return age
end

# @param check_file_exist [String]  check if file exists
# @return nothing
# @raise Wrong entries, not exists filename 
# @advice good to use checked roster and sheet files with the TeamSheet Checker tool
def self.check_file_exist(filename) 
 raise IOError, "Error, file #{filename} not found on the current directory " unless File.exists?(filename)
end

#age_check273( 'oki', 23)

#eos_effect

end 
