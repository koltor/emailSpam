#ajout des librairie necessaire
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require "google_drive"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config("config.json")
ws = session.spreadsheet_by_key("1yebVyqIp0mIDCwU8sAocaXj_Cl4RmbG9qtswsPwr6pY").worksheets[0]

#je viens definir l'url et ouvre la page à scrapper
puts "demarrage de l'analyse"
page2 = Nokogiri::HTML(open("http://annuaire-des-mairies.com/"))
t = 14387 - 327
for i in 69..99
	lien2 = page2.css('td a')[i]['href']

 #je viens me deplacer vers la page du val-d'oise
	lien =  "http://annuaire-des-mairies.com/" + lien2
	page = Nokogiri::HTML(open(lien))
	puts "direction " + lien
	puts "################################################################"


	tab = []
 #compteur pour repéré le nombre de mairies à analiser
	k  = 0
 #boucle qui vien récupéré les liens de chaque mairie
		page.css('a.lientxt').each do|x|
				tab << x['href']
			k += 1
		end

 #affiche le nobre de mairies trouvé
 
	puts tab
	puts
	t += k
	puts k.to_s + "mairies trouvé"
  puts t.to_s + "mairies trouvé au total"
	mail = Hash.new('0')
	puts "demarrage de la recherche des mails"
	#boucle qui viens récupéré les emails dans chaque page web de chauqe mairies et l'ajoute dans un tableau mail
	tab.each_with_index do |x,j|
		begin
			page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/" + x))
		rescue
			page = false
		end
		if page
			page.css("p").each do |a| 
				mail[x.reverse.slice(5..-1).reverse] = a.text if a.text.include?("@")
			end	
				ws[t + j - k + 1, 1] = mail[x.reverse.slice(5..-1).reverse]
  			ws[t + j - k + 1, 2] = x.reverse.slice(5..-1).reverse.slice(6..-1)
			puts (i + 1).to_s + " / " + "100" + " " + (j + 1).to_s + " / " + k.to_s + " " + x.reverse.slice(5..-1).reverse # permet de suivre en temps réel le code travaillé
		end
	end
	ws.save
end
puts "analyse terminé"
puts mail

