#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# @title esms_tools module 
# A module to provide extra tool to ESMS text football manager 
# Available tools:
# age_check: Check if teamsheets meet the age requirements (1 playerU21 on line-up another on the bench) ; age limit also can be selected (default 21)
# important text files in "ISO-8859-1" encoding

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
    footballer = footballer.force_encoding("ISO-8859-15") #('UTF-8') # scrub from 2.1
    #p footballer.valid_encoding?
    roster_content = roster_content.force_encoding("ISO-8859-15") #.valid_encoding? # utf-8 wrong iso good
    m = /#{footballer}\s+\d+/.match(roster_content) #.force_encoding('UTF-8'))
    unless m  
     puts "Footballer not found in roster, check teamsheet file"
     exit  
    end  
   #print "El string de la búsqueda es: " 
   #puts m.string    # string donde se efectúa la búsqueda 
   #print "La parte del string que concuerda con la búsqueda es: " 
   #puts m[0]        # parte del string que concuerda con nuestra búsqueda
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
 puts "So the age limit condition is not fulfilled" unless age_cond
end

def self.ask_filename
 print "Enter the teamsheet file name (excluding the sht.txt part: ) "
 file = gets.chomp
 return file
end

def self.check_age_limit(age)
 age = age.to_i if age.is_a? String
 raise ArgumentError,"Error, age limit entry should be a valid footballer age value (1-99) in years " unless  (age.is_a? Integer) and (99 > age) and ( age >= 1)
end

def self.check_file_exist(filename) 
 raise IOError, "Error, file #{filename} not found on the current directory " unless File.exists?(filename)
end

#age_check
age_check( 'wat', 17)

#~ # Calcula la letra de control para el número de identificación dado  | Generate the entry id control letter.
#~ #
#~ # @param calcula para entrada [Número|Cadena] la letra de control asociada | yield for [Number|String] the control letter associated.
#~ # @return [String] letra de control de la entrada | the requested control letter of the entry.
#~ public 
#~ def self.letra(num) # letra o digito  de control del DNI/NIE
    #~ num = transform(num)
    #~ #doc = '0' + doc if doc.size == 6
    #~ #a = 0
    
    #~ CODIGO[(num.to_i % 23)].to_s
#~ end

#~ def self.validate_doc(ci) # validar documento
  #~ dig = ci[-1]
  #~ ci = ci[0..-2]
  #~ ci = transform(ci)
  #~ #p dig
  #~ #p letra(ci)
  #~ #p ci
  #~ letra(ci) == dig.upcase # pone en Mayúsculas
#~ end

#~ def self.get_random_dni # genera dni aleatorio
    #~ dni = rand(0..89999999).to_s # límite en 89 millones, no se sabe de mayor a la fecha
    #~ dni += letra(dni)
    #~ dni
#~ end

#~ def self.get_random_nie # genera nie aleatorio
    #~ #nie = LETRA[(rand(0..2))] ++ rand(0..9_999_999).to_s #parece que siempre asigna millones
    #~ nie = LETRA[(rand(0..2))] ++ rand(0..9999999).to_s
    #~ #p nie
    #~ letra = letra(nie.dup)
    #~ nie += letra
    #~ nie
#~ end
#~ #p get_random_dni  
#~ #p get_random_nie
#~ #p CODIGO[(79253302 % 23)].to_s
#~ #p transform(64798)
#~ #p transform('Z00019')
#~ #p transform('a01')
#~ #p transform(' _ 0a01')
#~ #p transform('9999792553302')
#~ #p letra(0)
#~ #p letra ('Y0760953') #not accept 0 first if is array int, thinks is octal number
#~ #p letra(1760953)
#~ #p validate_doc('79253302X')
#~ #p validate_doc('Y9253302B')
#~ #p validate_doc('1760953G')
#~ #p 014.trim

 #~ class << self  # alias
   #~ alias_method :get_control_letter, :letra
   #~ alias_method :control_letter, :get_control_letter
   #~ alias_method :control_digit, :get_control_letter
   #~ alias_method :validate , :validate_doc 
   #~ alias_method :validar , :validate  
   #~ alias_method :validar_doc , :validate_doc 
   #~ alias_method :random_dni, :get_random_dni
   #~ alias_method :random_nie, :get_random_nie
   #~ alias_method :generar_dni, :get_random_dni
   #~ alias_method :new_dni, :get_random_dni
   #~ alias_method :dni, :get_random_dni
   #~ alias_method :new_nie, :get_random_nie
   #~ alias_method :generar_nie, :get_random_nie
   #~ alias_method :nie, :get_random_nie   
 #~ end
end 
