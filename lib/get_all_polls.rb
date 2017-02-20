require 'fileutils'
require 'rest-client'
require 'nokogiri'





# CONFIG
# ======

URLS =
{
	:series =>
	{
		:url => "https://www.senscritique.com/series/sondages/",
		:pages => 1..11
	},
	:jeuxvideo =>
	{
		:url => "https://www.senscritique.com/jeuxvideo/sondages/",
		:pages => 1..27
	},
	:livres =>
	{
		:url => "https://www.senscritique.com/livres/sondages/",
		:pages => 1..10
	},
	:bd =>
	{
		:url => "https://www.senscritique.com/bd/sondages/",
		:pages => 1..13
	},
	:musique =>
	{
		:url => "https://www.senscritique.com/musique/sondages/",
		:pages => 1..27
	},
	:films =>
	{
		:url => "https://www.senscritique.com/films/sondages/",
		:pages => 1..132
	},
}

DATA_DIR = "../data"

USER_AGENT = "senscritique-polls-indexer/1.0 (+https://github.com/vincent-clipet/senscritique-polls-indexer)"

SLEEP_TIME = 30





# UTILS
# =====

def http_get(url)
	begin
		return RestClient.get(url, :user_agent => USER_AGENT)
	rescue Exception => exc
		puts "[ERROR] #{exc.backtrace}"
		exit 1
	end
end





# SCRIPT
# ======

URLS.keys.each do | key |
	FileUtils.mkdir_p("#{DATA_DIR}/#{key}")
end



URLS.each do | key, value |

	value[:pages].each do | i |

		# Build URL
		url = "#{value[:url]}tous/tous/page-#{i}.ajax"
		puts "[INFO] HTTP GET #{url}"

		# HTTP GET
		response = http_get(url)

		# Filename
		filename = "#{DATA_DIR}/#{key}/#{i.to_s.rjust(3, "0")}.html"

		# Nokogiri parsing
		parsed_html = Nokogiri::HTML(response.body)
		content = parsed_html.at_css('#polls-section').to_html()


		# Save page
		File.open(filename, 'w') do | f |
			f.write(content)
		end

		puts "[INFO] File #{filename} saved"

		# Avoid getting banned :)
		sleep(SLEEP_TIME)

	end


end