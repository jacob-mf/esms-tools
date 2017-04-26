# -*- coding: utf-8 -*-
require 'minitest/spec'
require 'minitest/pride'
require 'minitest/autorun'
require 'esms_tools'

describe EsmsTools do   # test module EsmsTools
  it 'age-checker should answer correctly' do
    good_team = 'oki'
    assert EsmsTools.age_check(good_team)

    wrong_team = 'tip'
    assert false, EsmsTools.age_check(wrong_team)
    
    error_team = 'err'
    assert_raises EsmsTools.age_check(error_team)
  end

  #~ it 'debe validar documentos oficiales | should validate official document id.' do
    #~ doc = '79253302V'
    #~ assert DniNie.validate(doc)
  #~ end

  #~ it 'debe validar números que incluyan puntos o guiones | should validate numbers even when using dots and dashes' do
     #~ doc = '1760953-G'
    #~ assert DniNie.validate_doc(doc)
 
     #~ doc = '0-0/011/B'
     #~ assert DniNie.validar_doc(doc)
     
     #~ doc = '00-0/12/N'
     #~ assert DniNie.validar(doc)
  #~ end

  #~ it 'debe fallar al recibir números de identificación no válidos | should not validate wrong id numbers' do
    #~ doc = '11112221V'
    #~ assert !DniNie.validate_doc(doc)
  #~ end

  #~ it 'debe generar DNI/NIE(s) válidos | should get a valid random dni/nie ids' do
    #~ doc = DniNie.get_random_dni
    #~ assert DniNie.validate_doc(doc)
    #~ doc = DniNie.get_random_nie
    #~ assert DniNie.validate_doc(doc)
  #~ end

  #~ it 'debe validar documentos de 6 cifras | should validate dni with 6 digits' do
    #~ doc = '3949383F'
    #~ assert DniNie.validar_doc(doc)
  #~ end

  #~ it 'debe de aceptar enteros como entrada | should accept integers as input' do
     #~ doc = 51_691_703
     #~ assert DniNie.letra(doc)
   #~ end

 
end
