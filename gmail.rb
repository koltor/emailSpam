require 'gmail'
require "google_drive"

session = GoogleDrive::Session.from_config("config.json")
ws = session.spreadsheet_by_key("1yebVyqIp0mIDCwU8sAocaXj_Cl4RmbG9qtswsPwr6pY").worksheets[0]

i = 1
while ws[i,1].empty? == false
i += 1
		envoi(ws[i,1],ws[i,2])
end	



def envoi(destinataire, perso)
	gmail = Gmail.connect("eamil", "mot de passe")

	gmail.deliver do  # or: gmail.deliver(email)
		to "#{destinataire}"
  	subject "thehackingproject"
  	text_part do
  	body "Bonjour,
Je m'appelle Maxence, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle The Hacking Project (http://thehackingproject.org/). Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.

Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{perso}, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{perso} !

Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80"
		end
	end
	gmail.logout
end



