class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

  get "/cards" do
    url = 'https://www.pokellector.com/sets/BS-Base-Set'
    html = Nokogiri::HTML5(URI.open(url))
    
    listingArr = html.css('div.plaque').collect.with_index { |el, index|
      # p el.text #test to see what the element was
      # p "******"
        { 
          scraped_element: el.text,
          cardName: el.text.gsub!(/\d+/,"").tr("[#", "").tr("-", "").strip,
          set_num: index + 1,
          id: index 
        }
    }    
     
    { cardList: listingArr }.to_json
    
  end

end
